I'll analyze these commits for regression issues according to the Tbricks app development checklist.

## Regression Analysis Results

### Critical Issues (Block Commit):
**None identified** - The changes implement async app creation which is architecturally sound.

### Medium Issues (Address Before Release):

**Issue 1: Incomplete State Management in Async Creation**
**File:** production/strategy/spread_quoter/shared/SpreaderLeg.cpp:1589
**Code:**
```cpp
Strategy::RequestResult createRequest =
        Strategy::SendAsyncCreateRequest(options,
                                        GetHedgeOrderStrategyParameters(...),
                                        *this);

TBSTATUS("Sent " << (paused ? "paused " : "") << " hedge: " << side << " " << volume << "@" << price << " request id: " << createRequest.GetRequestIdentifier());

m_hedgeRequests.emplace(createRequest.GetRequestIdentifier(), RequestData(paused, orderType));
```
**Impact:** The transition from synchronous `SendCreateRequest` to `SendAsyncCreateRequest` changes the strategy creation lifecycle. Previously, the strategy was immediately available and subscribed. Now there's a gap between request and fulfillment where the strategy state exists only in `m_hedgeRequests` map.

**Specific Concerns:**
1. **Recovery scenario**: If the app crashes/recovers between async request and `HandleStrategyRequestReply`, the pending hedge request in `m_hedgeRequests` will be lost (it's in-memory only)
2. **Pause/Delete handling**: If app receives pause/delete request while hedge requests are pending in `m_hedgeRequests`, those requests may not be properly cleaned up
3. **Timer initialization**: The hedge timer starts only after `HandleStrategyRequestReply` completes, potentially delaying timeout detection

**Fix Required:** 
- Add recovery logic in constructor to check for orphaned child strategies
- In `HandlePauseRequest`/`HandleDeleteRequest`, check and handle pending `m_hedgeRequests`
- Consider persisting pending async requests or implementing request timeout

---

**Issue 2: Race Condition in HasHedges() Check**
**File:** production/strategy/spread_quoter/shared/SpreaderLeg.cpp:2581
**Code:**
```cpp
bool SpreaderLeg::HasHedges() const
{
    return HasHedgeOrders() || !m_immediateOrders.empty() || !m_orderMinionHedgeRequests.empty();
}

bool HasHedgeOrders() const
{
    return !m_hedges.empty() || !m_hedgeRequests.empty();
}
```
**Impact:** The check now includes `m_hedgeRequests` (pending async requests). However, there's a timing window where:
1. Async request is sent → `m_hedgeRequests` populated
2. `HasHedges()` returns true
3. Request fails in `HandleStrategyRequestReply` 
4. `m_hedgeRequests` is cleaned up
5. But app logic may have already made decisions based on HasHedges() == true

**Recommendation:** Add explicit failure handling in `HandleStrategyRequestReply` when `status` indicates failure, ensuring proper state cleanup and app notification.

---

**Issue 3: Potential Memory Leak in Error Path**
**File:** production/strategy/spread_quoter/shared/SpreaderLeg.cpp:1784-1815
**Code:**
```cpp
void SpreaderLeg::HandleStrategyRequestReply(const StrategyIdentifier & strategyId, 
                                             const Identifier & id,
                                             Status status,
                                             const String & status_text)
{
    TBSTATUS(__func__ << " request: " << id << " strategy id: " << strategyId << " status: " << status << " text: " << status_text);
    if (auto it = m_hedgeRequests.find(id); it != m_hedgeRequests.end())
    {
        // Handle hedge request
        const auto& requestData = it->second;

        m_strategyManager.Subscribe(this, strategyId);
        m_hedgeCreateRequests[id] = strategyId;
        auto& hedge = m_hedges[strategyId];
        // ... initialization ...
        
        m_hedgeRequests.erase(it);
    }

    HandleRequestReply(id, status, status_text);
}
```
**Impact:** If `status` indicates failure (not Status::OK), the code still:
- Subscribes to the (failed) strategy
- Adds to `m_hedgeCreateRequests`
- Creates entry in `m_hedges`
- Starts hedge timer for failed strategy

This will leave orphaned data structures and potentially start timers for non-existent strategies.

**Fix Required:**
```cpp
void SpreaderLeg::HandleStrategyRequestReply(const StrategyIdentifier & strategyId, 
                                             const Identifier & id,
                                             Status status,
                                             const String & status_text)
{
    TBSTATUS(__func__ << " request: " << id << " strategy id: " << strategyId 
             << " status: " << status << " text: " << status_text);
    
    if (auto it = m_hedgeRequests.find(id); it != m_hedgeRequests.end())
    {
        const auto& requestData = it->second;
        
        if (!status.IsOk()) {
            // Handle failure - notify handler, don't create orphaned structures
            TBERROR("Async hedge creation failed: " << status_text);
            m_handler.HandleInitialHedgeFailure(*this, 
                "Async hedge creation failed: " + status_text);
            m_hedgeRequests.erase(it);
            HandleRequestReply(id, status, status_text);
            return;
        }

        // Success path - proceed with subscription and initialization
        m_strategyManager.Subscribe(this, strategyId);
        // ... rest of success logic ...
    }

    HandleRequestReply(id, status, status_text);
}
```

### Minor Issues (Technical Debt):

**Issue 1: Naming Inconsistency**
**File:** Multiple files
**Code:** Renaming `ImmediateHedge` → `InitialHedge` throughout
**Suggestion:** While the renaming improves clarity (since hedges may not be IOC anymore with async creation), ensure all documentation and comments are updated to reflect this terminology change.

---

**Issue 2: Missing Tracepoints**
**File:** production/strategy/spread_quoter/shared/SpreaderLeg.cpp:1577-1591
**Suggestion:** Add tracepoints around async request lifecycle for performance monitoring:
```cpp
TRACEPOINT_GLOBAL(async_hedge_request_sent);
Strategy::RequestResult createRequest = Strategy::SendAsyncCreateRequest(...);
TRACEPOINT_GLOBAL(async_hedge_request_returned);
```

### Metadata Status Assessment:

✅ **COMPLETED ACTIONS:**
- No metadata changes detected in these commits
- No new parameters or calculated properties added
- No changes to app designer configuration

❌ **REQUIRED ACTIONS:**  
- None - this is a pure code change without metadata implications

### Evidence Summary:
- **Files analyzed:** 3 (SpreaderLeg.cpp, SpreaderLeg.h, SpreaderLegTLSD.cpp)
- **Methods reviewed:** 
  - `SendHedgeOrderStrategy()` - async creation implementation
  - `HandleStrategyRequestReply()` - new async completion handler
  - `HasHedges()` / `HasHedgeOrders()` - state checking logic
  - `CompletedInitialHedge()` (renamed from `CompletedImmediateHedge`)
- **Parameters checked:** RequestData structure for async request tracking
- **Streams verified:** StrategyManager subscription patterns

### Recommendations:

1. **Immediate (before merge):**
   - Add failure handling in `HandleStrategyRequestReply` to avoid orphaned data structures
   - Add explicit cleanup of `m_hedgeRequests` in pause/delete handlers

2. **Short-term (before release):**
   - Implement recovery logic for orphaned async requests
   - Add request timeout mechanism for async creation
   - Enhance logging around async request lifecycle

3. **Performance validation:**
   - Verify the async creation actually improves latency (per APP-47219 goals)
   - Test with app pooling enabled (per APP-47817)
   - Measure latency impact in scenario where pool is exhausted

## COMMIT DECISION:
**CONDITIONAL APPROVE** - The architectural change is sound and addresses the performance issue identified in APP-47219. However, the error handling path in `HandleStrategyRequestReply` must be fixed before release to production to prevent orphaned data structures when async requests fail.
