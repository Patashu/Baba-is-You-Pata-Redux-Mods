# Baba Is You Pata Redux Mods

Special thanks to JumboDS64 for initial LEAN implementation, lily for modloader and initial COPY/WITH/PERSIST/RESET implementation.

To install: Copy modloader.lua until Baba Is You/Data/Lua folder. Copy the rest into the World folder that you wish to use this mod.

**SLIP** - __Property__ Once per turn, objects standing on something SLIP will involuntarily move in the direction they're facing. If they did, voluntary movement (YOU, MOVE, COPY) is prevented that turn.

**SLIDE** - __Property__ Whenever a unit steps onto something that is SLIDE, it immediately moves again in the same direction. EMPTY IS SLIDE works.

**HATES** - __Verb__ Conditional STOP. If x HATES y, y is STOP to x. x HATES LEVEL causes x to be unable to move. x HATES EMPTY causes x to be unable to enter empty tiles.

**LIKES** - __Verb__ If x LIKES things, x can only step onto tiles that contain at least one thing it LIKES. BABA LIKES BABA causes blobs of BABA to stack. BABA LIKES EMPTY causes BABA to be unable to enter non-empty tiles, and causes blobs of BABA to break apart! KEKE LIKES ROCK, ROCK IS PUSH, KEKE IS YOU makes it so if BABA pushes a rock/keke stack around, the keke moves with the rock but can't leave the rock.

**SIDEKICK** - __Property__ Like a 90 degree counterpart to PUSH and PULL - Solid, and when a unit moves, SIDEKICK units on the tiles either side of it attempt to move as well.

**LAZY** - __Property__ Something that is LAZY can't push or pull. ROCK IS PUSH AND LAZY gives you sokoban style 'max 1' pushing. KEKE IS MOVE AND LAZY gives you moving actors that don't shive things around with them.

**STUBBORN** - __Property__ Something that is MOVE and STUBBORN doesn't turn around when it hits a wall.

**SPIN** - __Property__ Turns 90 degrees to the right at the end of each turn. Stacks!

**LEAN** - __Property__ At end of turn, faces the first direction it could move in: (right, forward, left, back). In general, follows the right wall.

**TURN** - __Property__ At end of turn, faces the first direction it could move in: (forward, right, left, back). In general, turns right when it hits a wall.

**MOONWALK / DRUNK / DRUNKER / SKIP** - __Property__ Causes movement (YOU/MOVE/PUSH/PULL/SHIFT/SLIDE/SLIP/SIDEKICK/COPY) to be 180, 90 or 45 degrees 'wrong' respectively. SKIP makes movements go 2 tiles instead of 1! All 4 stack with each other and themselves!

**TALL** - __Property__ This unit is considered to be both float levels simultaneously.

**ONEWAY** - __Property__ Prevents units from walking onto it from the tile it faces (like a directional STOP).

**COPY** - __Verb__ If x COPY y, whenever y moves, x will try to move the same way.

**WITH** - __Infix Condition__ True if the unit has the specified property.

Baba is You Discord server: https://discord.gg/GGbUUse

You may use these mods in your mod pack or custom world with attribution!
