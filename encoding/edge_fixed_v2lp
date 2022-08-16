#include "input.lp".

moveto(C',C,T) :- nextto(C',D,C), position(robot(R),C',T-1), old_move(R,D,T).

% - edge collision --------------------------------------------------------------
poss_ec(R,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(fixed),C,T-1), position(robot(R),C2,T-1).
{ec(R,T)} :- poss_ec(R,T).
:- 1!={ec(_,_)}.
% Earliest conflict:
:- ec(_,T), poss_ec(_,T2), T>T2.

% - try sidestep:
sidestep(T) :- ec(_,T).

poss_sidestep(P,T) :- position(robot(fixed),P,T), sidestep(T2), T<T2,  old_move(fixed,(DX,DY),T+1), nextto(P,(DY,DX),P2), not position(robot(R),P2,T+1) : fixed!=R, isRobot(robot(R)).
poss_sidestep(P,T) :- position(robot(fixed),P,T), sidestep(T2), T<T2,  old_move(fixed,(DX,DY),T+1), nextto(P,(-DY,-DX),P2), not position(robot(R),P2,T+1) : fixed!=R, isRobot(robot(R)).

{sidestep(P,T)} :- poss_sidestep(P,T).

% - else wait
wait :- not poss_sidestep(_,_).

% perform exactly one of the possible sidesteps
:- 0{sidestep(_,_)}0, sidestep(_), poss_sidestep(_,_).
:- 2{sidestep(_,_)}, sidestep(_).

% choose latest possible sidestep:
:- sidestep(_,T), poss_sidestep(_,T2), T<T2.

% keep old moves before sidestep:
move(fixed,D,T) :- old_move(fixed,D,T), sidestep(_,T2), T<=T2.

% do sidestep on own path:
% if this side is possible (note X and Y switched):
move(fixed,( DY, DX),T+1) :- old_move(fixed,(DX,DY),T+1), sidestep(P,T), nextto(P,(DY,DX),_).
% else other side (X and Y switched):
move(fixed,(-DY,-DX),T+1) :- old_move(fixed,(DX,DY),T+1), sidestep(P,T), not nextto(P,(DY,DX),_).

% go back:
move(fixed,(-DX,-DY),T+(2*(T2-T))) :- move(fixed,(DX,DY),T+1), sidestep(P,T), sidestep(T2).

% keep but delay old moves after sidestep:
move(fixed,D,T+(2*(T3-T2))) :- old_move(fixed,D,T), sidestep(_,T2), T>T2, sidestep(T3).

move(fixed,D,T+1) :- old_move(fixed,D,T), not sidestep(_,_), wait.

#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.
