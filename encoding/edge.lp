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
poss_ec(R,R2,T) :- moveto(C2,C,T), moveto(C,C2,T), C < C2, position(robot(R),C,T-1), position(robot(R2),C2,T-1).
{ec(R,R2,T)} :- poss_ec(R,R2,T).
:- 1!={ec(_,_,_)}.
:- ec(_,_,T), poss_ec(_,_,T2), T>T2. 

% - path length
atleastpl(R,T) :- old_move(R,_,T), ec(R,_,_).
atleastpl(R,T) :- old_move(R,_,T), ec(_,R,_).
atleastpl(R,L) :- atleastpl(R,L+1), L>=0.
       pl(R,L) :- atleastpl(R,L), not atleastpl(R,L+1).

% - robot with shorter pathlength has to perform sidestep to avoid edge collision:
sidestep(R ,T) :- ec(R,R2,T), pl(R,L), pl(R2,L2), L<=L2.
sidestep(R2,T) :- ec(R,R2,T), pl(R,L), pl(R2,L2), L> L2.

% - possible sidesteps on old path before conflict (at least 3 adjacent cells):
poss_sidestep(R,P,T) :- position(robot(R),P,T), 3{nextto(P,_,_)}, sidestep(R,T2), T<T2.
{sidestep(R,P,T)} :- poss_sidestep(R,P,T).%, not poss_sidestep(R,_,T2), T>T2, time(T2).

% replan if no sidestep is possible
replan(R,T) :- not poss_sidestep(R,_,_), sidestep(R,_), ec(R,_,T).
replan(R,T) :- not poss_sidestep(R,_,_), sidestep(R,_), ec(_,R,T).

% perform exactly one of the possible sidesteps
:- 0{sidestep(R,_,_)}0, sidestep(R,_), not replan(R,_).
:- 2{sidestep(R,_,_)}, sidestep(R,_).

% choose latest possible sidestep:
:- sidestep(R,_,T), poss_sidestep(R,_,T2), T<T2.

% keep old moves before sidestep:
move(R,D,T) :- old_move(R,D,T), sidestep(R,_,T2), T<=T2.

% do sidestep on own path:
move(R,(-DX,-DY),T+2) :- move(R,(DX,DY),T+1), sidestep(R,P,T).

% if this side is possible (note X and Y switched):
move(R,( DY, DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), nextto(P,(DY,DX),_).
% else other side (X and Y switched):
move(R,(-DY,-DX),T+1) :- old_move(R,(DX,DY),T+1), sidestep(R,P,T), not nextto(P,(DY,DX),_).

% keep old moves after sidestep but delay by two timesteps
move(R,D,T+2) :- old_move(R,D,T), sidestep(R,_,T2), T>T2.

move(R,D,T) :- old_move(R,D,T), not sidestep(R,_).

% replan:
% keep moves until conflict
% TODO

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

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
