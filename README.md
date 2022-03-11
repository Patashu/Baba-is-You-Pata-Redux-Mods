# Baba Is You Pata Redux Mods

Special thanks to lily for initial COPY/PERSIST/RESET implementation.

To install: Copy everything in Lua and Sprites to the world folder you want to use this mod. Edit the world folder's world_data.txt. Add mods=1 under [general] (like it is for the one in this repository).

**SLIP** - __Property__ Once per turn, objects standing on something SLIP will involuntarily move in the direction they're facing. If they did, voluntary movement (YOU, MOVE, COPY) is prevented that turn.

**SLIDE** - __Property__ Whenever a unit steps onto something that is SLIDE, it immediately moves again in the same direction. EMPTY IS SLIDE works.

**HATES** - __Verb__ Conditional STOP. If x HATES y, y is STOP to x. x HATES LEVEL causes x to be unable to move. x HATES EMPTY causes x to be unable to enter empty tiles.

**LIKES** - __Verb__ If x LIKES things, x can only step onto tiles that contain at least one thing it LIKES. BABA LIKES BABA causes blobs of BABA to stack. BABA LIKES EMPTY causes BABA to be unable to enter non-empty tiles, and causes blobs of BABA to break apart! KEKE LIKES ROCK, ROCK IS PUSH, KEKE IS YOU makes it so if BABA pushes a rock/keke stack around, the keke moves with the rock but can't leave the rock.

**SIDEKICK** - __Property__ Like a 90 degree counterpart to PUSH and PULL - Solid, and when a unit moves, SIDEKICK units on the tiles either side of it attempt to move as well.

**LAZY** - __Property__ Something that is LAZY can't push or pull. ROCK IS PUSH AND LAZY gives you sokoban style 'max 1' pushing. KEKE IS MOVE AND LAZY gives you moving actors that don't shive things around with them.

**MOONWALK / DRUNK / DRUNKER / SKIP** - __Property__ Causes movement (YOU/MOVE/PUSH/PULL/SHIFT/SLIDE/SLIP/SIDEKICK/COPY) to be 180, 90 or 45 degrees 'wrong' respectively. SKIP makes movements go 2 tiles instead of 1! All 4 stack with each other and themselves!

**TALL** - __Property__ This unit is considered to be both float levels simultaneously.

**ONEWAY** - __Property__ Prevents units from walking onto it from the tile it faces (like a directional STOP).

**COPY** - __Verb__ If x COPY y, whenever y moves, x will try to move the same way.

**RESET** - __Property__ If YOU touches RESET, the game is undone back to the starting state. However, anything that is currently PERSIST will remain as-is.

**PERSIST** - __Property__ PERSIST units are unaffected by undoing. Edge cases: If a PERSIST unit is created by conversion, the thing that converted into it does not come back. If a PERSIST unit is destroyed, it does not come back when you undo. If a unit is currently PERSIST, it will remain unchanged when YOU RESET, even if it used to not be PERSIST.

**PUSHES, PULLS, STOPS, SINKS, DEFEATS, OPENS, SHIFTS, SWAPS, MELTS** - __Verb__ Conditional versions of common properties. x PUSHES y is like 'y is PUSH only when x is the pushee'. x PULLS y is like 'y is PULL only when x is the pushee'. x STOPS y is like 'x is STOP only when y is the pushee' (note that is is backwards from HATES - use that to match the rest of the patterning!). x SINKS y is like 'x is SINK only for y'. x DEFEATS y is like 'x is DEFEAT only for y'. x OPENS y is like 'x is OPEN/y is SHUT only for x/y'. x SHIFTS y is like 'x is SHIFT only for y'. x SWAPS y is like 'x is SWAP but only for moving onto y' (and not e.g. in the opposite case of y moving onto x!). x MELTS y is like 'x is HOT and y is MELT only for x/y'.

**TOPPLE** - __Property__ When a stack of topplers are on a tile, they eject themselves in the facing direction to form a line (first moves 0 tiles, second moves 1 tile, third moves 2 tiles, etc). Happens during movement after SHIFT.

(Potential future words: TELES, LAUNCH (bab GOOOO), YEET (from bab), LAUNCHES, SLIPS, SLIDES, SIDEKICKS, SEENBY/FACEDBY, SI (reverse IS), NORESET/NOUNDO (components of PERSIST), LEVEL IS PERSIST/NOUNDO/NORESET, other!PERSIST (as in bab STAY THER, Randomiser's Persistence did it finally), GIVE/TAKE, HOLD/HOLDS/TRAP/TRAPS/CONTAIN/CONTAINS/CARRY/CARRIES/DRIVE/DRIVES (hold, its two components and its verbified versions), wins, floats, booms, falls (dir), nudges (dir), selects, saves (more verbified properties), ON variant that also checks floating state, JUKE/JUKES (passive-only verbified swap), FLY/PHASE (like bab), IGNORES/CANT (from bab, can't interact with objects/properties respectively), new STUBBORN (prevents the object from being moved by other objects)/FIRM (negates fear/nudge/fall/back), UNWIN/STINKY/EJECT/GOAL/WON, STABLE (propertyified x is x and also blocks x is not x), ITSELF (from bab), ISOLATED ( https://discord.com/channels/556333985882439680/560913551586492475/937368165338476634 ), BLOCKS (property blocks property = anything with property A can't have property B), return of LESS, STRAFE, SINGLET/CAPPED/STRAIGHT/CORNER/EDGE/INNER, etc, POWERS (verbified power), make HATES/LIKES stronger than PHANTOM, WANT (reverse FEAR), cg5's WRAP/PORTAL/FIND/EVIL/REPENT/ACTIVE/BLOCKED again, GOTO (one-way tele, like bab RIT HERE but different), DISLIKE (like a fear for ON, plus x hates y), DUPE (makes another of itself), BECOME/FEEL (halves of IS, idea by jan), rename SIDEKICK to SLUE (joke), GROUND (stops FALL), BEING/THATWAS (infix condition that checks what you used to be ala revert), VERBING (feeling but for over verbs, like bab THAT X), SPECTRAL (co-exist with empty), MIDDLE (trollbreeder: 5th directionless direction), MEANS/ISALSO (the classic idea, redefines what text pieces mean), SCRAWL/PRINT (WRITE-ified HAS/MAKE)), Combined text blocks (like IS NOT, IS YOU or NOT BABA), YOU8WAY (lets you move diagonally by using the you2 keys), ZOOM (old mod that makes all movement infinite)

Baba is You Discord server: https://discord.gg/GGbUUse

You may use/modify these mods for your mod pack or custom world with attribution!

If you find a bug or missing feature or think an edge case should work differently for your puzzle, open an github issue or poke me on Discord (Patashu#8123 on the Baba is You Discord server)!
