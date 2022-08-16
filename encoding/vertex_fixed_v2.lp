#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.
#include "input.lp".

% - Vertex conflict
poss_vc(fixed,R,T) :- position(robot(fixed),P,T), position(robot(R),P,T), fixed!=R.
{vc(fixed,R,T)} :- poss_vc(fixed,R,T).
:- 1!={vc(_,_,_)}.
:- vc(_,_,T), poss_vc(_,_,T2), T>T2.

% Sidestep needed:
% Robot R waits, fixed robot collides
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(R),P,T-1), position(robot(R),P,T), position(robot(R),P,T+1),
                                     position(robot(fixed),P2,T-1), position(robot(fixed),P,T), position(robot(fixed),P3,T+1), P!=P2.

side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P,T-1), position(robot(R),P2,T-1), position(robot(fixed),P2,T+1), position(robot(R),P ,T+1).
                                                                       
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P,T), position(robot(fixed),P,T+1).
                                    
side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(R),P,T+1), position(robot(fixed),P,T-1), position(robot(fixed),P2,T+1), P!=P2.              

side_vc(fixed,R,T) :- vc(fixed,R,T), position(robot(fixed),P,T-1), position(robot(fixed),P,T).                          
                            
%side_vc(99,99,99).

sidestep(fixed,T)  :- side_vc(fixed,R,T).

poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, old_move(fixed,(DX,DY),T), nextto(P,(DY,DX),P2), not position(robot(R),P2,T) : fixed!=R, isRobot(R).
poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, old_move(fixed,(DX,DY),T), nextto(P,(-DY,-DX),P2), not position(robot(R),P2,T) : fixed!=R, isRobot(R).

poss_sidestep(fixed,P,T) :- position(robot(fixed),P,T-1), sidestep(fixed,T2), T<=T2, not old_move(fixed,_,T).

{sidestep(fixed,P,T)} :- poss_sidestep(fixed,P,T).

% perform exactly one of the possible sidesteps
:- 0{sidestep(fixed,_,_)}0, sidestep(fixed,_), poss_sidestep(fixed,_,_).
:- 2{sidestep(fixed,_,_)}, sidestep(fixed,_).

% choose latest possible sidestep:
:- sidestep(fixed,_,T), poss_sidestep(fixed,_,T2), T<T2.

% keep old moves before sidestep:
move(fixed,D,T) :- old_move(fixed,D,T), sidestep(fixed,_,T2), T<T2.

pos_move(fixed,D,T) :-  nextto(P,D,P2), direction(D), not position(robot(_),P2,T), position(robot(R),P,T), position(robot(R),P3,T-1), P2!=P3, position(robot(R),P4,T+1), P2!=P4, R!=fixed, not old_move(fixed,_,T), sidestep(fixed,P,T).

{move(fixed,D,T)} :- pos_move(fixed,D,T).
:- 0{move(fixed,_,T)}0, pos_move(fixed,_,T).
:- 2{move(fixed,_,T)}, pos_move(fixed,_,T).

wait :- not move(fixed,_,T), sidestep(fixed,P,T).

wait_vc(fixed,R,T) :- not side_vc(fixed,R,T), vc(fixed,R,T).
wait_vc(fixed,R,T) :- side_vc(fixed,R,T), not poss_sidestep(fixed,_,_).

wait :- wait_vc(fixed,R,_).

% elif this side is possible (note X and Y switched):
move(fixed,( DY, DX),T) :- old_move(fixed,(DX,DY),T), sidestep(fixed,P,T), nextto(P,(DY,DX),_).
% else other side (X and Y switched):
move(fixed,(-DY,-DX),T) :- old_move(fixed,(DX,DY),T), sidestep(fixed,P,T), not nextto(P,(DY,DX),_).

% go back:
move(fixed,(-DX,-DY),T+(2*(T2-T))+2) :- move(fixed,(DX,DY),T), sidestep(fixed,P,T), sidestep(fixed,T2).

% keep but delay old moves after sidestep:
move(fixed,D,T+(2*(T3-T2))+3) :- old_move(fixed,D,T), sidestep(fixed,_,T2), T>=T2, sidestep(fixed,T3).

% wait at start:
move(fixed,D,T+1) :- old_move(fixed,D,T), not sidestep(fixed,_,_), wait.
