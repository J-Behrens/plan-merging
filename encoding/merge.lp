#include "input.lp".

old_move(R,D,T):- occurs(object(robot,R),action(move,D),T).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

% - edge collision --------------------------------------------------------------
moveto(C',C,T) :- nextto(C',D,C), position(R,C',T-1), move(R,D,T).
ec(R,R2) :- moveto(C2,C,T), moveto(C,C2,T), C < C2, position(R,C,T-1), position(R2,C2,T-1).

% - switch plan to avoid edge collision
move_ec(R2,D,T) :- old_move(R ,D,T), ec(R,R2).
move_ec(R ,D,T) :- old_move(R2,D,T), ec(R,R2).
move_ec(R ,D,T) :- old_move(R ,D,T), not ec(R,_), not ec(_,R).

% - vertex collision ------------------------------------------------------------
vc(P,R,R2,T) :- position(robot(R),P,T), position(robot(R2),P,T), R<R2.

% - path length
pl(R,T) :- old_move(R,P,T), not old_move(R,P,T+1).

% - wait to avoid vertex collision
wait(R) :- vc(P,R,R2,T), pl(R,L), pl(R2,L2), L<=L2.
move(R,D,T) :- move_ec(R,D,T), not wait(R).

move(R,D,T+1) :- move_ec(R,D,T), wait(R).

#show.
#show occurs(object(robot,R), action(move,D),     T) :    move(R,D,T).
#show init/2.
