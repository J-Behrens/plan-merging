#include "input.lp". #include "sidestep.lp".

moveto(C',C,T) :- nextto(C',D,C), position(robot(R),C',T-1), old_move(R,D,T).

% - edge collision --------------------------------------------------------------
poss_ec(R,T) :- moveto(C2,C,T), moveto(C,C2,T), C != C2, position(robot(fixed),C,T-1), position(robot(R),C2,T-1).
{ec(R,T)} :- poss_ec(R,T).
:- 1!={ec(_,_)}.
% Earliest conflict:
:- ec(_,T), poss_ec(_,T2), T>T2.

% - sidestep --------------------------------------------------------------------
sidestep(T) :- ec(_,T).

% keep but delay old moves after sidestep:
move(fixed,D,T+2) :- old_move(fixed,D,T), sidestep(_,T2), T>=T2.

#show. #show occurs(object(robot,R),action(move,D),T) : move(R,D,T). #show init/2.
