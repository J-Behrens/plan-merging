move(R,D,T) :- occurs(object(robot,R),action(move,D),T).
time(T)   :- move(_,_,T).
time(T-1) :- time(T), T>0.

position(robot(R),P,0) :- init(object(robot,R),value(at,P)).

% - move/3 ----------------------------------------------------------------------
position(robot(R),(X+DX,Y+DY),T) :- move(R,(DX,DY),T), position(robot(R),(X,Y),T-1).

% - inertia ---------------------------------------------------------------------
position(robot(R),C,T) :- position(robot(R),C,T-1), not move(R,_,T), time(T).

% - Vertex conflict
vc :- S={position(robot(_),P,T)}, position(robot(R),P,T), S>1.

#show vc/0.
