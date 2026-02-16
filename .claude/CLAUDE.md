# Global Instructions for Claude Code & Copilot CLI

## Workspace Management
Check ~/Claude for existing project directories. Scan 2-3 recent files in each 
subdirectory to determine the best match for the current task. If no good fit 
is found after the first prompt, create a new appropriately-named folder 
(consider using dates or project names). After making the selection, clear the 
directory listing from context to save tokens.

For Jira cases, e.g. SPRJ-74910, APP-48374, are managed from ~/Claude/cases/`case number`.
If a case is given them managed it from there, creating a folder if required.

## Git Commit Behavior
**CRITICAL**: Do not add files to git commits unless I explicitly give permission. 
You can stage changes for review, but always ask before committing. When showing 
me what you've staged, be clear about what will be committed.

All commits should begin with a case number, e.g. "APP-48374: ", if you do not have
one, do not guess, ask.

## File Handling and Executable Scripts
**CRITICAL - No File Extensions on Executables**:
- NEVER create executable scripts with file extensions (.py, .sh, .bash, etc.)
- Executable scripts should have NO extension - this is standard Unix convention
- Use proper shebang lines (#!/usr/bin/env python3, #!/bin/bash, etc.)
- For files without extensions, use the `file` command or check the shebang line
  to determine the file type before editing
- Examples:
  - ✓ CORRECT: `jira-fetch` (executable Python script, no extension)
  - ✗ WRONG: `jira-fetch.py` (has .py extension)
  - ✓ CORRECT: `gather-materials` (executable shell script, no extension)
  - ✗ WRONG: `gather-materials.sh` (has .sh extension)

## Working Style
- I prefer the automated, agentic approach - proceed with confidence
- If you need clarification, ask, but don't be overly cautious
- I'm comfortable with C++, Python, and shell scripting

## Communication
- Be concise - I can read code and understand technical concepts
- Don't over-explain unless I ask for details
- It's fine to make reasonable assumptions and move forward

## Teach First Philosophy
For every project, write a detailed FORJOHN.md file that explains the whole project in plain language.
Explain the technical architecture, the structure of the codebase, and how the various parts are connected, the technologies used, why we made thse technical decisions, and lessons I can learn from it (this should include the bugs we ran into and how we fixed them, potential pitfalls and how to avoid them in the future, new technologies used, how good engineers think and work, best practice, etc).
It should be very engaging to read; don't make it sound like boring technical documentation/textbook. Where appropriate, use analogies and anecdotes to make it more understandable and memorable.

## Available Tools

These are on your PATH

### fetch_appdoc
Fetch Confluence documentation pages to stdout or file.
Usage:
- `fetch_appdoc --page-id 610950726` - Fetch by page ID to stdout
- `fetch_appdoc --page-id "https://...com/content/610950726"` - Parse ID from URL
- `fetch_appdoc --page-id 123 | rg "pattern"` - Pipe to search
- `fetch_appdoc --page-id 123 --json | jq '.title'` - JSON output
- `fetch_appdoc --page-id 123 -o file.md` - Save to file
- `fetch_appdoc --space SPACE --page-title "Title"` - Legacy mode

### tbjira
Access Jira tickets.
Usage: `tbjira TICKET-123` - Get ticket details
Usage: `tbjira --jql "query"` - Search tickets
