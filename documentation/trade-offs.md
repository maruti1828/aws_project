# Engineering trade-offs

| Choice | Upside | Downside / risk | Possible mitigation |
|---|---|---|---|
| ALB | Central routing and target health | Additional cost and configuration | Monitor utilization and remove unused resources |
| Two-instance minimum | Baseline redundancy | Always-on compute expense | Right-size instances and schedule non-production environments |
| Three-instance maximum | Cost ceiling | Capacity ceiling under spikes | Load test and revise max capacity based on evidence |
| AMI-based provisioning | Repeatable launch baseline | Image drift and patching burden | Automate image builds and version rollout |
| Launch Template | Versioned launch settings | Old versions can remain in use | Document default version and use instance refresh |
| EBS snapshots | Recovery points | Snapshot storage cost and restore time | Define retention and test restores |
| Multi-AZ | AZ-level resilience | More resources and coordination | Verify capacity in each AZ |
| Public subnet lab instances | Avoids NAT Gateway cost | Not ideal production isolation | Use private subnets and controlled egress in production |
| Health checks | Stops routing to unhealthy targets | Aggressive checks can flap | Tune path, timeout, interval, and thresholds |

## Cost vs. availability

A minimum of two instances increases baseline cost but reduces reliance on one compute instance. A maximum of three limits cost exposure but also limits available scale. These values should be treated as a learning configuration until load testing and service objectives justify them.
