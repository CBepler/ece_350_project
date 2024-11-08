# Processor
## NAME (NETID)

Christian Bepler (cgb45)

## Description of Design

It assumes not taken for branches and fixes that by inserting nops for the decode and execute stages when it is proven wrong.

## Bypassing

All of the bypassing logic for the execute stage is in the bypass module that checks what can be grabbed from the memory and writeback stage and stalls
if needed.

All of the bypassing for the memory stage is in the memBypass module. Which is really just lw -> sw bypassing.

## Stalling

It stalls the fetch and decode phase for multiplies.

It stalls by looping the instructions in the fetch and decode stage until the stall is released.

## Optimizations

N/A

## Bugs

No known bugs
