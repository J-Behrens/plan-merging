%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Grid size X: 5
%Grid size Y: 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program base.

%plan
position(robot(1),(3,2),0). position(robot(2),(4,1),0). position(robot(3),(5,2),0). position(robot(4),(3,6),0). position(robot(5),(4,7),0). position(robot(6),(5,6),0). occurs(object(robot,1),action(move,(1,0)),1). occurs(object(robot,2),action(move,(0,1)),1). occurs(object(robot,3),action(move,(-1,0)),1). occurs(object(robot,4),action(move,(1,0)),1). occurs(object(robot,5),action(move,(0,-1)),1). occurs(object(robot,6),action(move,(-1,0)),1). occurs(object(robot,1),action(move,(0,1)),2). occurs(object(robot,2),action(move,(0,1)),2). occurs(object(robot,3),action(move,(0,1)),2). occurs(object(robot,4),action(move,(0,-1)),2). occurs(object(robot,5),action(move,(0,-1)),2). occurs(object(robot,6),action(move,(0,-1)),2). occurs(object(robot,1),action(move,(0,1)),3). occurs(object(robot,2),action(move,(0,1)),3). occurs(object(robot,3),action(move,(0,1)),3). occurs(object(robot,4),action(move,(0,-1)),3). occurs(object(robot,5),action(move,(0,-1)),3). occurs(object(robot,6),action(move,(0,-1)),3). occurs(object(robot,1),action(move,(1,0)),4). occurs(object(robot,2),action(move,(-1,0)),4). occurs(object(robot,3),action(move,(-1,0)),4). occurs(object(robot,4),action(move,(1,0)),4). occurs(object(robot,5),action(move,(-1,0)),4). occurs(object(robot,6),action(move,(1,0)),4). occurs(object(robot,1),action(move,(1,0)),5). occurs(object(robot,2),action(move,(-1,0)),5). occurs(object(robot,3),action(move,(-1,0)),5). occurs(object(robot,4),action(move,(1,0)),5). occurs(object(robot,5),action(move,(-1,0)),5). occurs(object(robot,6),action(move,(1,0)),5). occurs(object(robot,1),action(move,(0,-1)),6). occurs(object(robot,2),action(move,(0,-1)),6). occurs(object(robot,3),action(move,(0,1)),6). occurs(object(robot,4),action(move,(1,0)),6). occurs(object(robot,5),action(move,(-1,0)),6). occurs(object(robot,6),action(move,(0,1)),6). position(robot(6),(4,6),1). position(robot(5),(4,6),1). position(robot(4),(4,6),1). position(robot(3),(4,2),1). position(robot(2),(4,2),1). position(robot(1),(4,2),1). position(robot(1),(4,3),2). position(robot(2),(4,3),2). position(robot(3),(4,3),2). position(robot(4),(4,5),2). position(robot(5),(4,5),2). position(robot(6),(4,5),2). position(robot(6),(4,4),3). position(robot(5),(4,4),3). position(robot(4),(4,4),3). position(robot(3),(4,4),3). position(robot(2),(4,4),3). position(robot(1),(4,4),3). position(robot(1),(5,4),4). position(robot(2),(3,4),4). position(robot(3),(3,4),4). position(robot(4),(5,4),4). position(robot(5),(3,4),4). position(robot(6),(5,4),4). position(robot(6),(6,4),5). position(robot(5),(2,4),5). position(robot(4),(6,4),5). position(robot(3),(2,4),5). position(robot(2),(2,4),5). position(robot(1),(6,4),5). position(robot(1),(6,3),6). position(robot(2),(2,3),6). position(robot(3),(2,5),6). position(robot(4),(7,4),6). position(robot(5),(1,4),6). position(robot(6),(6,5),6).

%init
init(object(node, 1), value(at, (1, 4))).
init(object(node, 2), value(at, (7, 4))).

init(object(node, 7), value(at, (3, 2))).
init(object(node, 17), value(at, (3, 4))).
init(object(node, 27), value(at, (3, 6))).
init(object(node, 8), value(at, (4, 2))).
init(object(node, 19), value(at, (5, 4))).
init(object(node, 15), value(at, (6, 3))).
init(object(node, 20), value(at, (6, 4))).
init(object(node, 25), value(at, (6, 5))).
init(object(node, 28), value(at, (4, 6))).
init(object(node, 18), value(at, (4, 4))).
init(object(node, 33), value(at, (4, 7))).
init(object(node, 29), value(at, (5, 6))).
init(object(node, 23), value(at, (4, 5))).
init(object(node, 13), value(at, (4, 3))).
init(object(node, 3), value(at, (4, 1))).
init(object(node, 9), value(at, (5, 2))).
init(object(node, 11), value(at, (2, 3))).
init(object(node, 16), value(at, (2, 4))).
init(object(node, 21), value(at, (2, 5))).
init(object(robot,1), value(at,(3,2))).
init(object(robot,2), value(at,(4,1))).
init(object(robot,3), value(at,(5,2))).
init(object(robot,4), value(at,(3,6))).
init(object(robot,5), value(at,(4,7))).
init(object(robot,6), value(at,(5,6))).
init(object(shelf,1), value(at,(2,3))).
init(object(product,1),value(on,(1,1))).
init(object(shelf,2), value(at,(1,4))).
init(object(product,2),value(on,(2,1))).
init(object(shelf,3), value(at,(2,5))).
init(object(product,3),value(on,(3,1))).
init(object(shelf,4), value(at,(6,3))).
init(object(product,4),value(on,(4,1))).
init(object(shelf,5), value(at,(7,4))).
init(object(product,5),value(on,(5,1))).
init(object(shelf,6), value(at,(6,5))).
init(object(product,6),value(on,(6,1))).
init(object(order,1),value(pickingStation,1)).
init(object(order,1),value(line,(1,1))).
init(object(order,2),value(pickingStation,1)).
init(object(order,2),value(line,(2,1))).
init(object(order,3),value(pickingStation,1)).
init(object(order,3),value(line,(3,1))).
init(object(order,4),value(pickingStation,1)).
init(object(order,4),value(line,(4,1))).
init(object(order,5),value(pickingStation,1)).
init(object(order,5),value(line,(5,1))).
init(object(order,6),value(pickingStation,1)).
init(object(order,6),value(line,(6,1))).
