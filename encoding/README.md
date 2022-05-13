## Encodings:
### [Single Agent:](../main/encoding/single_agent.lp)
- Generates a plan for a given instance without avoiding conflicts
- Basically asprilo-M encoding with integrity constraints for conflicts commented out
### [Visualization with clingraph:](../main/encoding/viz.lp)
- Needed for clingraph to visualize plans
### [Simple Wait:](../main/encoding/simple_wait.lp)
- Resolves one vertex conflict per agent
- Agent with smaller or equal path length waits one timestep at the beginning
