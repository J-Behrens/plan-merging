# Plan Merging
This project is about merging single agent plans so that the resulting plan is conflict free.

## Edge conflicts
Can be resolved by doing a sidestep or taking alternative routes (if possible) or by switching plans (only in anonymous MAPF).

## Vertex conflicts
Can be resolved by letting agents wait or by taking alternative routes.

### Simple Wait:
- Agents have different path length, no follow up conflicts
- Agent with smaller path length waits one timestep

  ![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Vertex-Conflicts/3x4_unequal/3x4_unequal.gif "unmerged and merged plan animation")
