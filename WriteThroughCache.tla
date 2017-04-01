MODULE WriteThroughCache

EXTENDS Naturals,Sequences,MemoryInterface

VARIABLES wmem,ctl,buf,cache,memQ

CONSTANT QLen

ASSUME (QLen \in Nat) /\ (QLen > 0)

M == INSTANCE InternalMemory WITH mem <- wmem