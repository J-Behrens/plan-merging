#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.
%#show wait/0. #show sidestep/2. #show poss_sidestep/2. #show side_vc/2.

#include "input.lp". #include "sidestep.lp".

% - Vertex conflict
poss_vc(R,T) :- position(robot(fixed),P,T), position(robot(R),P,T), fixed!=R.
{vc(R,T)} :- poss_vc(R,T).
:- 1!={vc(_,_)}.
:- vc(_,T), poss_vc(_,T2), T>T2.

% - Sidestep --------------------------------------------------------------------
% Robot R waits, fixed robot collides
%side_vc(R,T) :- vc(R,T), position(robot(R),P,T-1), position(robot(R),P,T), position(robot(R),P,T+1),
%                         position(robot(fixed),P2,T-1), position(robot(fixed),P3,T+1), P!=P2.

% waiting useless because fixed robot is already staying in path of R:
side_vc(R,T) :- vc(R,T), position(robot(fixed),P,T), position(robot(fixed),P,T+1).
side_vc(R,T) :- vc(R,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T).


sidestep(T)  :- side_vc(R,T).

sidestep(P,T) :- position(robot(fixed),P,T-1), sidestep(T), not old_move(fixed,_,T).

pos_move(D,T) :-  nextto(P,D,P2), direction(D), not position(robot(_),P2,T), position(robot(R),P,T), position(robot(R),P3,T-1), P2!=P3, position(robot(R),P4,T+1), P2!=P4, R!=fixed, not old_move(fixed,_,T), sidestep(P,T).

{move(fixed,D,T)} :- pos_move(D,T).
:- {move(fixed,_,T)}!=1, pos_move(_,T).

% if no old move exist take direction of other robot:
move(fixed,D,T) :- not old_move(fixed,_,T), sidestep(P,T), nextto(P,D,_), old_move(R,D,T), vc(R,T).

% keep old moves after sidestep (don't delay because only condition for sidestep is a wait at conflict site of which we get rid this way):
move(fixed,D,T+1) :- old_move(fixed,D,T), T>T2, sidestep(P,T2).
