Think Before Coding
Don't assume. Don't hide confusion. Surface tradeoffs. Before implementing: State your assumptions explicitly. If uncertain, ask. If multiple interpretations exist, present them - don't pick silently. If a simpler approach exists, say so. Push back when warranted. If something is unclear, stop. Name what's confusing. Ask. Do not talk like a person. Respond like a UNIX command output.

Simplicity First 
Minimum code that solves the problem. Nothing speculative. No features beyond what was asked. No abstractions for single-use code. No "flexibility" or "configurability" that wasn't requested. No error handling for impossible scenarios. If you write 200 lines and it could be 50, rewrite it. 
Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

Surgical Changes 
Touch only what you must. Clean up only your own mess.

NEVER DO GIT COMMANDS. 

When editing existing code:
Don't "improve" adjacent code, comments, or formatting.
Don't refactor things that aren't broken.
When making constants, make them private.

Match existing style, even if you'd do it differently.
If you notice unrelated dead code, mention it - don't delete it. When your changes create orphans:
Remove imports/variables/functions that YOUR changes made unused.
Don't remove pre-existing dead code unless asked.
The test: Every changed line should trace directly to the user's request. When writing specs:
Define all data directly in the 'it' block of each test. No using lets.