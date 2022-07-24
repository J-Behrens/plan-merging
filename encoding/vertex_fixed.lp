#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.

#include "input.lp".
time(0..M) :- M=#max{T : old_move(_,_,T)}.

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - positions:
position(robot(R),(X+DX,Y+DY),T) :-     old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not old_move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

% - Vertex conflict
poss_vc(fixed,R2,T) :- position(robot(fixed),P,T), position(robot(R2),P,T), fixed!=R2.
poss_vc(R,fixed,T) :- position(robot(R),P,T), position(robot(fixed),P,T), R!=fixed. 
{vc(R,R2,T)} :- poss_vc(R,R2,T).
:- 1!={vc(_,_,_)}.
:- vc(_,_,T), poss_vc(_,_,T2), T>T2.

% Sidestep needed:
% Robot R waits, fixed robot collides
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(R),P,T-1), position(robot(R),P,T), position(robot(R),P,T+1),
                                     position(robot(fixed),P2,T-1), position(robot(fixed),P,T), position(robot(fixed),P3,T+1), P!=P2.
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(R),P,T-1), position(robot(R),P,T), position(robot(R),P,T+1),
                                     position(robot(fixed),P2,T-1), position(robot(fixed),P,T), position(robot(fixed),P3,T+1), P!=P2.

side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P ,T-1), position(robot(R),P2,T-1), position(robot(fixed),P2,T+1), position(robot(R),P ,T+1).
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(R),P ,T-1), position(robot(fixed),P2,T-1), position(robot(R),P2,T+1), position(robot(fixed),P ,T+1).
                                                                        
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T), position(robot(fixed),P,T+1).
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T), position(robot(fixed),P,T+1).    
                                     
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(R),P,T+1), position(robot(fixed),P,T-1), position(robot(fixed),P2,T+1), P!=P2.              
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(R),P,T+1), position(robot(fixed),P,T-1), position(robot(fixed),P2,T+1), P!=P2.

side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(R),P,T-1), position(robot(fixed),P,T+1), position(robot(fixed),P2,T-1), position(robot(fixed),P2,T), P!=P2.
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(R),P,T-1), position(robot(fixed),P,T+1), position(robot(fixed),P2,T-1), position(robot(fixed),P2,T), P!=P2.

side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T).
side_vc(R,fixed,T) :- vc(R,fixed,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T).                            
                            
side_vc(99,99,99).

sidestep(fixed,T)  :- side_vc(fixed,R2,T).
sidestep(fixed,T)  :- side_vc(R,fixed,T).

poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, old_move(fixed,(DX,DY),T), nextto(P,(DY,DX),P2), not position(robot(R2),P2,T) : fixed!=R2, isRobot(R2).
poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, old_move(fixed,(DX,DY),T), nextto(P,(-DY,-DX),P2), not position(robot(R2),P2,T) : fixed!=R2, isRobot(R2).

poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, not old_move(fixed,_,T), isRobot(robot(R2)).

{sidestep(fixed,P,T)} :- poss_sidestep(fixed,P,T).

% perform exactly one of the possible sidesteps
:- 0{sidestep(R,_,_)}0, sidestep(R,_), poss_sidestep(R,_,_).
:- 2{sidestep(R,_,_)}, sidestep(R,_).

% choose latest possible sidestep:
:- sidestep(R,_,T), poss_sidestep(R,_,T2), T<T2.

% Keep moves of uninvolved robots:
move(R,D,T) :- old_move(R,D,T), not sidestep(R,_,_), not wait(R).

% keep old moves before sidestep:
move(R,D,T) :- old_move(R,D,T), sidestep(R,_,T2), T<T2.

pos_move(R,D,T) :-  nextto(P,D,P2), direction(D), not position(robot(_),P2,T), position(robot(R2),P,T), position(robot(R2),P3,T-1), P2!=P3, position(robot(R2),P4,T+1), P2!=P4, R2!=fixed, not old_move(R,_,T), sidestep(R,P,T).

{move(R,D,T)} :- pos_move(R,D,T).
:- 0{move(R,_,T)}0, pos_move(R,_,T).
:- 2{move(R,_,T)}, pos_move(R,_,T).

wait(fixed) :- not move(fixed,_,T), sidestep(R,P,T).

wait_vc(fixed,R,T) :- not side_vc(fixed,R,T), vc(fixed,R,T).
wait_vc(R,fixed,T) :- not side_vc(R,fixed,T), vc(R,fixed,T).
wait_vc(fixed,R,T) :- side_vc(fixed,R,T), not poss_sidestep(fixed,_,_).
wait_vc(R,fixed,T) :- side_vc(R,fixed,T), not poss_sidestep(fixed,_,_).

wait(fixed) :- wait_vc(fixed,R2,_).
wait(fixed) :- wait_vc(R,fixed,_).

% elif this side is possible (note X and Y switched):
move(R,( DY, DX),T) :- old_move(R,(DX,DY),T), sidestep(R,P,T), nextto(P,(DY,DX),_).
% else other side (X and Y switched):
move(R,(-DY,-DX),T) :- old_move(R,(DX,DY),T), sidestep(R,P,T), not nextto(P,(DY,DX),_).

% go back:
move(R,(-DX,-DY),T+(2*(T2-T))+2) :- move(R,(DX,DY),T), sidestep(R,P,T), sidestep(R,T2).

% keep but delay old moves after sidestep:
move(R,D,T+(2*(T3-T2))+3) :- old_move(R,D,T), sidestep(R,_,T2), T>=T2, sidestep(R,T3).

% wait at start:
move(R,D,T+1) :- old_move(R,D,T), not sidestep(R,_,_), wait(R).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
