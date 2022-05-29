#include "input.lp".
time(T) :- old_move(_,_,T).
time(T-1) :- time(T), T>0.

old_move(R,D,T):- occurs(object(robot,R),action(move,D),T).

% - move/3 ----------------------------------------------------------------------
position(robot(R),(X+DX,Y+DY),T) :- old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).

% - inertia ---------------------------------------------------------------------
position(robot(R),C,T) :- position(robot(R),C,T-1), not old_move(R,_,T), time(T).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

% - edge collision --------------------------------------------------------------
moveto(C',C,T) :- nextto(C',D,C), position(robot(R),C',T-1), old_move(R,D,T).
ec(R,R2,T) :- moveto(C2,C,T), moveto(C,C2,T), C < C2, position(robot(R),C,T-1), position(robot(R2),C2,T-1).

% - path length
pl(R,L) :- L=#max{T:old_move(R,_,T)}, isRobot(robot(R)).

% - sidestep to avoid edge collision
sidestep(R ,T) :- ec(R,R2,T), pl(R,L), pl(R2,L2), L<=L2.
sidestep(R2,T) :- ec(R,R2,T), pl(R,L), pl(R2,L2), L> L2.

%- possible sidesteps on old path before conflict (at least 3 adjacent cells):
poss_sidestep(R,P,T) :- position(robot(R),P,T), 3{nextto(P,_,_)}, sidestep(R,T2), T<T2.
{sidestep(R,P,T)} :- poss_sidestep(R,P,T).
:- {sidestep(R,_,_)}!=1, sidestep(R,_), not replan.

% keep old moves before sidestep:
move(R,D,T) :- old_move(R,D,T), sidestep(R,_,T2), T<T2.

% do sidestep:
% if possible:
move(R,(DY,DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), nextto(P,(DY,DX),_).
move(R,(-DY,-DX),T+2) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), nextto(P,(DY,DX),_).
% else:
move(R,(-DY,-DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), not move(R,(DY,DX),T).
move(R,(DY,DX),T+2) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), not move(R,(DY,DX),T).

% replan if no sidestep possible
replan :- not poss_sidestep(R,_,_), sidestep(R,_).

% TODO

% keep old moves after sidestep but delay by two timesteps
move(R,D,T+2) :- old_move(R,D,T), sidestep(R,_,T2), T>=T2.

move(R,D,T) :- old_move(R,D,T), not sidestep(R,_).

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
