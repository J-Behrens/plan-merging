#include "input.lp".
time(T) :- move(_,_,T).
time(T-1) :- time(T), T>0.

% - move/3 ----------------------------------------------------------------------
position(robot(R),(X+DX,Y+DY),T) :- move(robot(R),(DX,DY),T), position(robot(R),(X,Y),T-1).

% - inertia ---------------------------------------------------------------------
position(robot(R),C,T) :- position(robot(R),C,T-1), not move(robot(R),_,T), time(T).

old_move(R,D,T) :- occurs(object(robot,R),action(move,D),T).

% - Vertex conflict
vc(S,P,R,T) :- S={position(robot(_),P,T)}, position(robot(R),P,T), S>1.

%% determine biggest conflict
atleastvc(1..S,P,R,T) :- vc(S,P,R,T).
vc_max(S,P,R,T) :- atleastvc(S,P,R,T), not atleastvc(S+1,_,R,_).

% - Path length
pl(R,T) :- position(robot(R),P,T), not position(robot(R),_,T+1), vc(_,_,R,_).

% - Robot waitings if path lengths are all same
{wait(R,W) : W=0..S-1, vc_max(S,P,R,T)}.	% Add: check if path lengths are equal

% must wait if part of conflict (one can wait 0)
:- not wait(R,_), vc(_,P,R,T).

% not same wait durations
:- wait(R,W), wait(R2,W), vc(S,P,R,T), vc(S,P,R2,T), R<R2.

% - Wait effects:
move(R,D,T  ) :- old_move(R,D,T), not wait(R,_).
move(R,D,T  ) :- old_move(R,D,T),     wait(R,0).
move(R,D,T+S) :- old_move(R,D,T),     wait(R,S).

#show.
#show occurs(object(robot,R),action(move,D),T) : move(R,D,T).
#show init/2.
%#show wait/2.
