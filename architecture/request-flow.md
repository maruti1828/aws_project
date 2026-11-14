# Architecture and request flow

## High-level flow

```text
Client
  |
  v
Internet Gateway
  |
  v
Application Load Balancer
  |
  v
Listener rule
  |
  v
Target Group (health checks)
  |             |
  v             v
EC2 instance A  EC2 instance B
  \             /
   \           /
    Auto Scaling Group
       |
       +-- Launch Template
               |
               +-- AMI
```

An optional third EC2 target can be launched when a configured scaling policy increases desired capacity.

## Control plane vs. data plane

- **Data plane:** Client requests flow through the ALB to healthy Target Group targets.
- **Control plane:** The ASG, Launch Template, health-check integration, and scaling policy manage the fleet.

## Important behavior

- ALB health checks influence whether a target receives new traffic.
- ASG health checks and desired capacity influence whether an instance is replaced.
- A replacement restores capacity; a scaling policy increases capacity in response to demand.
- EBS is block storage attached to an instance; snapshots are point-in-time backup artifacts.
