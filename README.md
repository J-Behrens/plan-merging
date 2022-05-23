# Plan Merging
#### This project is about merging single agent plans so that the resulting plan is conflict free.

### [merge.py:](merge.py)
```sh
usage: merge.py [-h] -i INSTANCE [-e ENCODING] [-s SINGLE] [-t] [-v]

optional arguments:
  -h, --help            show this help message and exit
  -i INSTANCE, --instance INSTANCE
                        Instance file
  -e ENCODING, --encoding ENCODING
                        Merging encoding
  -s SINGLE, --single SINGLE
                        Get single agent plans
  -t, --test            Test merging encoding
  -v, --visualize       Visualize output with asprilo visualizer
```

## Edge conflicts
#### Happen if two agents move along the same edge at the same time (left GIF).
#### Can be resolved by doing a sidestep or taking alternative routes (right GIF) or by switching plans (middle GIF, anonymous MAPF).
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Edge-Conflicts/4x2_edge.gif "unmerged and merged plan animation")

## Vertex conflicts
#### Happen if multiple agents are at the same vertex at the same time (left GIF).
Can be resolved by letting agents wait (right GIF) or by taking alternative routes.
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Vertex-Conflicts/3x4_unequal/3x4_unequal.gif "unmerged and merged plan animation")
