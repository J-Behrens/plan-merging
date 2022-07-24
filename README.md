# Plan Merging
<details open><summary><strong>About</strong></summary>

#### This project is about merging single agent plans so that the result is a valid multi agent plan that is free of the following conflicts:
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

### An instance containing initials and single agent plans in asprilo format can be merged by using [merge.py:](merge.py)
<details open><summary><strong>Usage</strong></summary>

```sh
usage: merge.py [-h] -i INSTANCE [-r RETRIES] [-s] [-v]
  -i INSTANCE, --instance INSTANCE
                        Instance file
optional arguments:
  -h, --help            show this help message and exit
  -r RETRIES, --retries RETRIES
                        Number of retries per robot
  -s, --single          Get single agent plans and add to instance
  -v, --visualize       Visualize output with asprilo visualizer
```

The solution can be obtained from the created temp.lp file. (When interrupted it is also possible to obtain a partial solution from temp.lp.)

</details>

The strategy used in this project does not guarantee optimality nor completeness.
