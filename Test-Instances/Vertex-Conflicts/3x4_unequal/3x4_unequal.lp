%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Grid size X: 3
%Grid size Y: 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program base.

%plan
position(robot(1),(1,2),0). position(robot(2),(2,1),0).
position(robot(1),(2,2),1). position(robot(2),(2,2),1).
position(robot(1),(3,2),2). position(robot(2),(2,3),2).
position(robot(1),(3,2),3). position(robot(2),(2,4),3).
occurs(object(robot,1),action(move,(1,0)),1). occurs(object(robot,2),action(move,(0,1)),1).
occurs(object(robot,1),action(move,(1,0)),2). occurs(object(robot,2),action(move,(0,1)),2).
                                              occurs(object(robot,2),action(move,(0,1)),3). 



%init
init(object(node, 2), value(at, (2, 1))).
init(object(node, 5), value(at, (2, 2))).
init(object(node, 8), value(at, (2, 3))).
init(object(node, 6), value(at, (3, 2))).
init(object(node, 4), value(at, (1, 2))).
init(object(node, 11), value(at, (2, 4))).
init(object(robot,1), value(at,(1,2))).
init(object(robot,2), value(at,(2,1))).
init(object(shelf,1), value(at,(3,2))).
init(object(product,1),value(on,(1,1))).
init(object(shelf,2), value(at,(2,4))).
init(object(product,2),value(on,(2,2))).
init(object(order,1),value(pickingStation,1)).
init(object(order,1),value(line,(1,1))).
init(object(order,2),value(pickingStation,2)).
init(object(order,2),value(line,(2,2))).
