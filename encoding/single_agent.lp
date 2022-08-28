shelf(S)                   :- init(object(shelf,S),_).
position(         (X,Y)  ) :- init(object(node, _),value(at,(X,Y))).
position(shelf(S),(X,Y),0) :- init(object(shelf,S),value(at,(X,Y))).

position(robot(robot_id),(X,Y),0) :- init(object(robot,robot_id),value(at,(X,Y))).

% Move actions
time(1..horizon).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

{ move(robot(robot_id),D,T) : direction(D) } 1 :- time(T).

% - move/3 ----------------------------------------------------------------------
position(robot(robot_id),C,T) :- move(robot(robot_id),D,T), position(robot(robot_id),C',T-1), nextto(C',D,C).
                :- move(robot(robot_id),D,T), position(robot(robot_id),C ,T-1), not nextto(C ,D,_).

% - inertia ---------------------------------------------------------------------
position(robot_id,C,T) :- position(robot(robot_id),C,T-1), not move(robot(robot_id),_,T), time(T).


% - auxiliaries -----------------------------------------------------------------
 :- { position(robot(robot_id),C,T) } != 1, time(T).    % REDUNDANT but PERFORMANT?


% - goal ------------------------------------------------------------------------
atGoal(robot(robot_id)) :- position(shelf(robot_id),C,0), position(robot(robot_id),C,horizon).
:- not atGoal(robot(robot_id)).

#show.
#show occurs(object(robot,robot_id),action(move,D),T) : move(robot(robot_id),D,T).
