# Global Instructions for Claude Code

## Workspace Management
Check ~/Claude for existing project directories. Scan 2-3 recent files in each 
subdirectory to determine the best match for the current task. If no good fit 
is found after the first prompt, create a new appropriately-named folder 
(consider using dates or project names). After making the selection, clear the 
directory listing from context to save tokens.

## Git Commit Behavior
**CRITICAL**: Do not add files to git commits unless I explicitly give permission. 
You can stage changes for review, but always ask before committing. When showing 
me what you've staged, be clear about what will be committed.

## File Handling
For files without extensions, use the `file` command or check the shebang line 
to determine the file type before editing. Remember that executable scripts 
shouldn't have file extensions per Unix convention.

## Working Style
- I prefer the automated, agentic approach - proceed with confidence
- If you need clarification, ask, but don't be overly cautious
- I work in a corporate environment (BTCS/Broadridge) but also on personal projects
- I'm comfortable with C++, Python, and shell scripting

## Communication
- Be concise - I can read code and understand technical concepts
- Don't over-explain unless I ask for details
- It's fine to make reasonable assumptions and move forward
