MODULE InternalMemory

EXTENDS MemoryInterface

VARIABLES mem,   \* current state of the memory 
          ctl,   \* ctl[p] is the status of proc p's request
          buf    \* buf[p] contains the request or response

IInit ==                              \* initial predicate
    /\ mem \in [Adr -> Val]           \* initially, memory locations map an address to any value
    /\ ctl = [ p \in Proc -> "rdy" ]  \* each proc is ready to issue requests
    /\ buf = [ p \in Proc -> NoVal ]  \* each buf[p] is uninitialized
    /\ memInt \in InitMemInt          \* memInt is a member of InitMemInt

TypeInvariant ==
    /\ mem \in [Adr -> Val]                              \* mem is a function from Adr to Val
    /\ ctl \in [Proc -> {"rdy","busy","done"}]           \* ctl[p] can be those possible values
    /\ buf \in [Proc -> MReq \union Val \union {NoVal}]  \* buf[p] is a request or response
