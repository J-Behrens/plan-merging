## Encodings:
### [single_agent.lp:](../encoding/single_agent.lp)
- Generates a plan for a given instance without avoiding conflicts
- Basically asprilo-M encoding with integrity constraints for conflicts commented out
### [viz.lp:](../encoding/viz.lp)
- Needed for clingraph to visualize plans
- Pipe clingo output like this:
```sh
clingo ... --outf=2 | clingraph --viz-encoding=viz.lp --out=animate --engine=neato --dir='clingraph' --select-model=0 --type=digraph --view --sort=asc-int
```
### [edge.lp:](../encoding/edge.lp)
- Resolves edge conflicts of non-anon. MAPF by letting the agent with shorter or equal pathlength perform a sidestep
### [simple_wait.lp:](../encoding/simple_wait.lp)
- Resolves one vertex conflict per agent
- Agent with smaller or equal path length waits one timestep at the beginning
### [sized_wait.lp:](../encoding/sized_wait.lp)
- Extended version of simple wait
- Detects size of conflicts
- Able to resolve multiple vertex conflicts per agent by resolving the biggest conflict an agent is involved in
