%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Grid size X: 4
%Grid size Y: 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program base.

%plan
occurs(object(robot,1),action(move,(1,0)),1). occurs(object(robot,2),action(move,(-1,0)),1).
occurs(object(robot,1),action(move,(1,0)),2). occurs(object(robot,2),action(move,(-1,0)),2).

%init
init(object(node, 2), value(at, (2, 1))).
init(object(node, 6), value(at, (2, 2))).
init(object(node, 3), value(at, (3, 1))).
init(object(node, 7), value(at, (3, 2))).
init(object(node, 8), value(at, (4, 2))).
init(object(node, 5), value(at, (1, 2))).
init(object(robot,1), value(at,(2,2))).
init(object(robot,2), value(at,(3,2))).
init(object(shelf,1), value(at,(4,2))).
init(object(product,1),value(on,(1,1))).
init(object(shelf,2), value(at,(1,2))).
init(object(product,2),value(on,(2,2))).
init(object(order,1),value(pickingStation,1)).
init(object(order,1),value(line,(1,1))).
init(object(order,2),value(pickingStation,2)).
init(object(order,2),value(line,(2,2))).
