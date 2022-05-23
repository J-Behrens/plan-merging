#include "input.lp".
time(T) :- old_move(_,_,T).
time(T-1) :- time(T), T>0.

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - move/3 ----------------------------------------------------------------------
position(robot(R),(X+DX,Y+DY),T) :- old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).

% - inertia ---------------------------------------------------------------------
position(robot(R),C,T) :- position(robot(R),C,T-1), not old_move(R,_,T), time(T).

% - Vertex conflict
vc(P,R,R2,T) :- position(robot(R),P,T), position(robot(R2),P,T), R<R2.

% - Path length
pl(R,T) :- position(robot(R),P,T), not position(robot(R),_,T+1).

% - Robot with shorter or equal path length waits to avoid vertex conflict
wait(R ) :- vc(P,R,R2,T), pl(R,L), pl(R2,L2), L<=L2.
wait(R2) :- vc(P,R,R2,T), pl(R,L), pl(R2,L2), L> L2.

% - Wait effects:
move(R,D,T  ) :- old_move(R,D,T), not wait(R).
move(R,D,T+1) :- old_move(R,D,T),     wait(R).

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
