# Plan Merging
#### This project is about merging single agent plans so that the resulting plan is conflict free.

## Edge conflicts
#### Happen if two agents move along the same edge at the same time (left GIF).
#### Can be resolved by doing a sidestep or taking alternative routes (right GIF) or by switching plans (middle GIF, anonymous MAPF).
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Edge-Conflicts/4x2_edge.gif "unmerged and merged plan animation")

## Vertex conflicts
#### Happen if multiple agents are at the same vertex at the same time (left GIF).
Can be resolved by letting agents wait (right GIF) or by taking alternative routes.
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Vertex-Conflicts/3x4_unequal/3x4_unequal.gif "unmerged and merged plan animation")

## Encodings:
### [Simple Wait:](../main/encoding/simple_wait.lp)
- Resolves one vertex conflict per agent
- Agent with smaller or equal path length waits one timestep at the beginning
