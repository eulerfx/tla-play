MODULE WriteThroughCache

EXTENDS Naturals, Sequences, MemoryInterface

VARIABLES wmem, ctl, buf, cache, memQ

CONSTANT QLen

ASSUME (QLen \in Nat) /\ (QLen > 0)

M == INSTANCE InternalMemory WITH mem <- wmem

Init ==
    /\ M!IInit
    /\ cache = [ p \in Proc -> [ a \in Adr -> NoVal ]]