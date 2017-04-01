MODULE MemoryInterface

VARIABLE memInt \* the state of the memory interface

CONSTANTS Send(_,_,_,_),    \* a Send(p,d,memInt,memInt') step represents processor p sending a value d to the memory, chaning state from memInt to memInt'
          Reply(_,_,_,_),   \* 
          InitMemInt,       \* a set of possible initial values of memInt
          Proc,             \* the set of processor identifiers
          Adr,              \* the set of memory addresses
          Val               \* the set of possible values that can be assigned to an address


\* the ASSUME statement asserts formally that the value of _ is a Boolean. But the only way to assert formally what the value *signifies* would be
\* to say what it actually equals - that is, to define Send rather than making it a parameter
ASSUME \A p,d,miOld,miNew : /\ Send(p,d,miOld,miNew) \in BOOLEAN
                            /\ Reply(p,d,miOld,miNew) \in BOOLEAN

\* the set of all requests - reads and writes
MReq == [op:{"Rd"}, adr:Adr] \union [op:{"Wr"}, adr:Adr, val:Val]                            

NoVal == CHOOSE v : v \notin Val