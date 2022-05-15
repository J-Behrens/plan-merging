## Encodings:
### [Single Agent:](../encoding/single_agent.lp)
- Generates a plan for a given instance without avoiding conflicts
- Basically asprilo-M encoding with integrity constraints for conflicts commented out
### [Visualization with clingraph:](../main/encoding/viz.lp)
- Needed for clingraph to visualize plans
### [Simple Wait:](../encoding/simple_wait.lp)
- Resolves one vertex conflict per agent
- Agent with smaller or equal path length waits one timestep at the beginning
### WIP [Sized Wait:](../encoding/sized_wait.lp)
- Able to resolve multiple conflicts per agent
- Detects size of conflicts
- Resolves all conflicts of an agent by resolving its biggest conflict

### WIP Iterative Wait:
