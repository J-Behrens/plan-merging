#include "input.lp".
time(0..M) :- M=#max{T : old_move(_,_,T)}.

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - positions:
position(robot(R),(X+DX,Y+DY),T) :-     old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not old_move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

% - Vertex conflict
vc(S,P,T) :- S={position(robot(_),P,T)}, position(robot(_),P,T), S>1.

% - Biggest conflict
atleastvc(S,P,T) :- vc(S,P,T).
atleastvc(S-1,P,T) :- atleastvc(S,P,T), S>2.
{vc_max(S,P,T)} :- atleastvc(S,P,T), not atleastvc(S+1,_,_).
:- {vc_max(_,_,_)}!=1.

% - Earliest:
:- vc_max(S,_,T), vc(S,_,T2), T>T2.


% - Path length:
atleastpl(R,T) :- old_move(R,_,T), position(robot(R),P,T2), vc_max(_,P,T2).
atleastpl(R,L) :- atleastpl(R,L+1), L>=0.
       pl(R,L) :- atleastpl(R,L), not atleastpl(R,L+1).

% - Robot waitings
1{wait(R,0..S-1)}1 :- position(robot(R),P,T), vc_max(S,P,T).

% not wait the same
:- wait(R,W), wait(R2,W), vc_max(S,P,T), position(robot(R),P,T), position(robot(R2),P,T), R<R2.

% robot with shorter plans wait longer
waits_longer(R2,R) :- wait(R,W), wait(R2,W2), W<W2.
longer_plan(R2,R) :- pl(R,L), pl(R2,L2), L<L2.
:- waits_longer(R2,R), vc_max(S,P,T), position(robot(R),P,T), position(robot(R2),P,T), R!=R2, longer_plan(R2,R).

% - Wait effects:
move(R,D,T  ) :- old_move(R,D,T), not wait(R,_).
move(R,D,T+W) :- old_move(R,D,T),     wait(R,W).

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
