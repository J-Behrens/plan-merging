move(R,D,T) :- occurs(object(robot,R),action(move,D),T).
time(0..M) :- M=#max{T : move(_,_,T)}.

position(robot(R),P,0) :- init(object(robot,R),value(at,P)).

position(robot(R),(X+DX,Y+DY),T) :-     move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

vc(fixed,R,P,T) :- position(robot(fixed),P,T), position(robot(R),P,T), fixed!=R.
vc(fixed,R,P,T) :- position(robot(R),P,T), position(robot(fixed),P,T), R!=fixed.

#show vc/4.
