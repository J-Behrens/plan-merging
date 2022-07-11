# Plan Merging
<details open><summary><strong>About</strong></summary>

#### This project is about merging single agent plans so that the resulting plan is conflict free.
<details><summary><strong>Edge conflicts</strong></summary>

- Happen if two agents move along the same edge at the same time (left GIF).
- Can be resolved by doing a sidestep or taking alternative routes (right GIF) or by switching plans (middle GIF, anonymous MAPF).
  
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Edge-Conflicts/4x2_edge.gif "unmerged and merged plan animation")

</details>

<details><summary><strong>Vertex conflicts</strong></summary>

- Happen if multiple agents are at the same vertex at the same time (left GIF).
- Can be resolved by letting agents wait (right GIF) or by taking alternative routes.
![alt text](https://github.com/J-Behrens/plan-merging/blob/main/Test-Instances/Vertex-Conflicts/3x4_unequal/3x4_unequal.gif "unmerged and merged plan animation")

</details>

</details>

## [merge.py:](merge.py)
```sh
usage: merge.py [-h] -i INSTANCE [-s] [-v]

optional arguments:
  -h, --help            show this help message and exit
  -i INSTANCE, --instance INSTANCE
                        Instance file
  -s, --single          Get single agent plans
  -v, --visualize       Visualize output with asprilo visualizer
```
