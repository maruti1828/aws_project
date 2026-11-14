# Design decisions

| Decision | Rationale | Revisit when |
|---|---|---|
| ALB as public entry point | Avoid exposing each application instance as a separate endpoint | HTTPS, WAF, authentication, or routing needs evolve |
| Target Group health checks | Avoid routing new requests to unhealthy targets | Health endpoint semantics or startup time change |
| ASG baseline of two | Keep more than one instance in normal operation | Workload and availability requirements are measured |
| Maximum capacity of three | Bound the learning environment's scale and cost | Load tests justify a larger ceiling |
| Launch Template | Standardize launch configuration | New AMI or instance settings are released |
| AMI | Consistent machine baseline | Patching and image pipeline mature |
| EBS snapshots | Provide volume recovery points | Backup retention and restore objectives are defined |
| Two Availability Zones | Reduce dependency on one AZ | Regional and multi-region resilience is required |

## Interview note

A design decision is stronger when you can explain the requirement, the alternative considered, the benefit, the cost, and the conditions under which you would revisit it.
