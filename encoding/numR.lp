atleast(R) :- init(object(robot,R), value(at,_)).
atleast(R-1) :- atleast(R), R>1.
r(R) :- atleast(R), not atleast(R+1).
#show r/1.
