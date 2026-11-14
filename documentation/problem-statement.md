# Problem statement

A single-instance web application can become unavailable when its EC2 instance fails and can become overloaded when request volume increases.

The design goal is to introduce a managed traffic entry point and a replaceable compute fleet:

- Use an ALB as the stable application entry point.
- Route requests to healthy registered targets.
- Use an ASG to maintain a baseline of two instances.
- Allow configured scaling up to three instances.
- Use Launch Templates and AMIs for consistent instance creation.
- Use EBS and snapshots for block storage and recovery exercises.

## Scope and non-goals

This project demonstrates infrastructure architecture and core AWS compute/networking concepts. It does not, by itself, prove a production SLA, measured throughput, zero downtime, application-level disaster recovery, or database high availability.
