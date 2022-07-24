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
### [edge_fixed.lp:](../encoding/edge_fixed.lp)
- Resolves an edge conflict of a fixed agent by letting it perform a sidestep or wait
### [vertex_fixed.lp:](../encoding/vertex_fixed.lp)
- Resolves a vertex conflict of a fixed agent by letting it perform a sidestep or wait
