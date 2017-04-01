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


\* a processing of a request MReq consists of a set of steps Req(p), Do(p), Rsp(p)

\* a Req(p) step represents the issuing of a request by proc p
\* the following describes the conditions under which it is enabled
\* and the state changes it enacts
Req(p) ==                                     \* proc p issues a request
    /\ ctl[p] = "rdy"                         \* enabled iff p is in the ready state
    /\ \E req \in MReq: 
        /\ Send(p,req,memInt,memInt')         \* send req on the MemoryInterface
        /\ buf' = [buf EXCEPT ![p] = req]     \* assign req to buf[p]
        /\ ctl' = [ctl EXCEPT ![p] = "busy"]  \* assign "busy" to ctl[p]
    /\ UNCHANGED mem   

\* a Do(p) step peforms proc p's request
Do(p) ==
    /\ ctl[p] = "busy"                                                          \* enabled if p's request has been issued via Req(p) step
    /\ mem' = IF buf[p].op = "Wr" THEN [mem EXCEPT ![buf[p].adr] = buf[p].val]  \* if a write, then update mem
              ELSE mem                                                          \* otherwise, leave mem unchanged
    /\ buf' = [buf EXCEPT ![p] = IF buf[p].op = "Wr" THEN NoVal                 \* for a write, leave buffer empty
                                 ELSE mem[buf[p].adr]]                          \* for a read, put the memory value into the buffer
    /\ ctl = [ctl EXCEPT ![p] = "done"]                                         \* assign "done" to ctl[p]
    /\ UNCHANGED memInt                            

Rsp(p) ==
    /\ ctl[p] = "done"                      \* enabled if request is in the done, but unreplied state`
    /\ Reply(p,buf[p],memInt,memInt')       \* sent the response on the interface
    /\ ctl' = [ctl EXCEPT ![p] = "rdy"]     \* return to the ready state
    /\ UNCHANGED <<mem,buf>>

INext == \E p \in Proc : Req(p) \/ Do(p) \/ Rsp(p)   \* the next-state action

ISpec == IInit /\ [][INext]<<memInt,mem,ctl,buf>>    \* the specification consits of the initial predicate
                                                     \* and a next-state action stuttering in memInt,mem,ctl,buf
                                                     \* NB: [X]<v> = X \/ (v' = v)

THEOREM ISPec => []TypeInvariant                     \* the spec implies the type invariant


