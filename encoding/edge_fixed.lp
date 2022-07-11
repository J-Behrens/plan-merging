#include "input.lp".
time(0..M) :- M=#max{T : old_move(_,_,T)}.

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - get positions:
position(robot(R),(X+DX,Y+DY),T) :-     old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not old_move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
moveto(C',C,T) :- nextto(C',D,C), position(robot(R),C',T-1), old_move(R,D,T).

% - edge collision --------------------------------------------------------------
poss_ec(fixed,R2,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(fixed),C,T-1), position(robot(R2),C2,T-1).
poss_ec(R,fixed,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(R),C,T-1), position(robot(fixed),C2,T-1).
{ec(R,R2,T)} :- poss_ec(R,R2,T).
:- 1!={ec(_,_,_)}.
% Earliest conflict:
:- ec(_,_,T), poss_ec(_,_,T2), T>T2.

% - try_sidestep:
sidestep(fixed,T) :- ec(_,_,T).

poss_sidestep(R,P,T) :- position(robot(R),P,T), sidestep(R,T2), T<T2,  old_move(R,(DX,DY),T+1), nextto(P,(DY,DX),P2), not position(robot(R2),P2,T+1) : R!=R2, isRobot(robot(R2)).
poss_sidestep(R,P,T) :- position(robot(R),P,T), sidestep(R,T2), T<T2,  old_move(R,(DX,DY),T+1), nextto(P,(-DY,-DX),P2), not position(robot(R2),P2,T+1) : R!=R2, isRobot(robot(R2)).

{sidestep(R,P,T)} :- poss_sidestep(R,P,T).

% - Robot with shorter or equal path length waits to avoid vertex conflict
wait(fixed) :- not poss_sidestep(fixed,_,_), not short(fixed).

% perform exactly one of the possible sidesteps
:- 0{sidestep(R,_,_)}0, sidestep(R,_), poss_sidestep(R,_,_).
:- 2{sidestep(R,_,_)}, sidestep(R,_).

% choose latest possible sidestep:
:- sidestep(R,_,T), poss_sidestep(R,_,T2), T<T2.

% Keep moves of uninvolved robots:
move(R,D,T) :- old_move(R,D,T), not sidestep(R,_,_), not wait(R), not short(R).

% keep old moves before sidestep:
move(R,D,T) :- old_move(R,D,T), sidestep(R,_,T2), T<=T2.

% do sidestep on own path:
% if this side is possible (note X and Y switched):
move(R,( DY, DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), nextto(P,(DY,DX),_).
% else other side (X and Y switched):
move(R,(-DY,-DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), not nextto(P,(DY,DX),_).

% go back:
move(R,(-DX,-DY),T+(2*(T2-T))) :- move(R,(DX,DY),T+1), sidestep(R,P,T), sidestep(R,T2).

% keep but delay old moves after sidestep:
move(R,D,T+(2*(T3-T2))) :- old_move(R,D,T), sidestep(R,_,T2), T>T2, sidestep(R,T3).

move(R,D,T+1) :- old_move(R,D,T), not sidestep(R,_,_), wait(R).
move(R,D,T-1) :- old_move(R,D,T), not sidestep(R,_,_), short(R).

% move in same direction other conflicting robot moves while no other direction is possible:
move(R,D,T2) :- old_move(R2,D,T2), replan(R,T), ec(R,R2,T), position(robot(R2),P,T2), 2{nextto(P,_,_)}2, not side(R,T).

%% sidestep:
side(R,T) :- replan(R,_), ec(R,R2,_), position(robot(R2),P,T), 3{nextto(P,_,_)}.
% to side:
move(R,D,T) :- move(R,D2,T-1), old_move(R2,D3,T), D!=D2, D!=D3, nextto(P,D,_), position(robot(R),P,T), side(R,T), ec(R,R2,_).
% back to position of conflict:
move(R,(-DX,-DY),T+X) :- move(R,(DX,DY),T-(X-1)), side(R,T), X=T-1..(TS+2)-TC, side(R,TS), replan(R,TC).
% keep but delay old moves after sidestep (delay= (time_sidestep + 1) - time_of_conflict):
move(R,D,T+X) :- old_move(R,D,T), X=(TS+3)-TC, side(R,TS), replan(R,TC), T>=TC. 

#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.
