robot(R)                   :- init(object(robot,R),_).
shelf(S)                   :- init(object(shelf,S),_).
isRobot( robot(R)        ) :- robot(R).
position(         (X,Y)  ) :- init(object(node, _),value(at,(X,Y))).
position(robot(R),(X,Y),0) :- init(object(robot,R),value(at,(X,Y))).
position(shelf(S),(X,Y),0) :- init(object(shelf,S),value(at,(X,Y))).

% Move actions
time(1..horizon).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

{ move(R,D,T) : direction(D) } 1 :- isRobot(R), time(T).

% - move/3 ----------------------------------------------------------------------
position(R,C,T) :- move(R,D,T), position(R,C',T-1),     nextto(C',D,C).
                :- move(R,D,T), position(R,C ,T-1), not nextto(C ,D,_).

% - inertia ---------------------------------------------------------------------
position(R,C,T) :- position(R,C,T-1), not move(R,_,T), isRobot(R), time(T).


% - auxiliaries -----------------------------------------------------------------
 :- { position(R,C,T) } != 1, isRobot(R), time(T).    % REDUNDANT but PERFORMANT?


% - goal ------------------------------------------------------------------------
atGoal(R) :- position(shelf(R),C,0), position(robot(R),C,horizon).
:- not atGoal(R), isRobot(robot(R)).

#show.
#show occurs(object(robot,R), action(move,D),     T) :    move(robot(R),D,T).
