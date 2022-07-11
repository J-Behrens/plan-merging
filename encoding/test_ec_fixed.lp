move(R,D,T) :- occurs(object(robot,R),action(move,D),T).
time(0..M) :- M=#max{T : move(_,_,T)}.

position((X,Y)) :- init(object(node,_),value(at,(X,Y))).
position(robot(R),P,0) :- init(object(robot,R),value(at,P)).

position(robot(R),(X+DX,Y+DY),T) :-     move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not move(R,_      ,T), position(robot(R),C    ,T-1), time(T).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
moveto(C',C,T) :- nextto(C',D,C), position(robot(R),C',T-1), move(R,D,T).

ec(fixed,R,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(fixed),C,T-1), position(robot(R),C2,T-1).
ec(fixed,R,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(R),C,T-1), position(robot(fixed),C2,T-1).

#show ec/3.
