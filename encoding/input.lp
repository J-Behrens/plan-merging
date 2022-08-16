robot(R)                     :- init(object(robot,R),_).
shelf(S)                     :- init(object(shelf,S),_).
isRobot(robot(R))            :- robot(R).
position(           (X,Y)  ) :- init(object(node, _),value(at,(X,Y))).
position(  robot(R),(X,Y),0) :- init(object(robot,R),value(at,(X,Y))).
position(  shelf(S),(X,Y),0) :- init(object(shelf,S),value(at,(X,Y))).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% Keep moves of uninvolved robots:
move(R,D,T) :- old_move(R,D,T), R!=fixed.

time(0..M) :- M=#max{T : old_move(_,_,T)}.

position(robot(R),(X+DX,Y+DY),T) :-     old_move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).
position(robot(R),C          ,T) :- not old_move(R,_      ,T), position(robot(R),C    ,T-1), time(T).
