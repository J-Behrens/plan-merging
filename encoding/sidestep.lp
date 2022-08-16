% sidestep right or left:
sidestep(P,T) :- position(robot(fixed),P,T-1), sidestep(T), old_move(fixed,(DX,DY),T), nextto(P,( DY, DX),P2), not position(robot(R),P2,T) : fixed!=R, isRobot(robot(R)).
sidestep(P,T) :- position(robot(fixed),P,T-1), sidestep(T), old_move(fixed,(DX,DY),T), nextto(P,(-DY,-DX),P2), not position(robot(R),P2,T) : fixed!=R, isRobot(robot(R)).

% keep old moves before sidestep:
move(fixed,D,T) :- old_move(fixed,D,T), sidestep(_,T2), T<T2.

% take this side if possible:
move(fixed,( DY, DX),T) :- old_move(fixed,(DX,DY),T), sidestep(P,T), nextto(P,(DY,DX),_).
% else other side:
move(fixed,(-DY,-DX),T) :- old_move(fixed,(DX,DY),T), sidestep(P,T), nextto(P,(-DY,-DX),_), not move(fixed,(DY,DX),T).

% go back:
move(fixed,(-DX,-DY),T+1) :- move(fixed,(DX,DY),T), sidestep(P,T).

% wait if no sidestep
side :- sidestep(_,_).
move(fixed,D,T+1) :- old_move(fixed,D,T), not side.
