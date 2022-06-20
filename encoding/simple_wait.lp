#include "input.lp".
time(0..M) :- M=#max{T : old_move(_,_,T)}.

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - positions:
position(robot(R),(X+DX,Y+DY),T) :-     old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not old_move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

% - Vertex conflict
{vc(R,R2)} :- position(robot(R),P,T), position(robot(R2),P,T), R<R2.
:- {vc(_,_)}!=1.

% - Path length
atleastpl(R,T) :- old_move(R,_,T), position(robot(R),P,T2), vc(R,_).
atleastpl(R,T) :- old_move(R,_,T), position(robot(R),P,T2), vc(_,R).
atleastpl(R,L) :- atleastpl(R,L+1), L>=0.
       pl(R,L) :- atleastpl(R,L), not atleastpl(R,L+1).

% - Robot with shorter or equal path length waits to avoid vertex conflict
wait(R ) :- vc(R,R2), pl(R,L), pl(R2,L2), L<=L2.
wait(R2) :- vc(R,R2), pl(R,L), pl(R2,L2), L> L2.

% - Wait effects:
move(R,D,T  ) :- old_move(R,D,T), not wait(R).
move(R,D,T+1) :- old_move(R,D,T),     wait(R).

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
