## Encodings:
### [Single Agent:](../encoding/single_agent.lp)
- Generates a plan for a given instance without avoiding conflicts
- Basically asprilo-M encoding with integrity constraints for conflicts commented out
### [Visualization with clingraph:](../main/encoding/viz.lp)
- Needed for clingraph to visualize plans
### [Sidestep:](../encoding/edge.lp)
- Resolves edge conflicts of non-anon. MAPF by letting the agent with shorter or equal pathlength perform a sidestep
### WIP Plan Switching:
- Resolves edge conflicts by switching plans (only for anon. MAPF)
### [Simple Wait:](../encoding/simple_wait.lp)
- Resolves one vertex conflict per agent
- Agent with smaller or equal path length waits one timestep at the beginning
### [Sized Wait:](../encoding/sized_wait.lp)
- Extended version of simple wait
- Detects size of conflicts
- Able to resolve multiple vertex conflicts per agent by resolving the biggest conflict an agent is involved in
