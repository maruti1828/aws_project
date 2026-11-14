# High availability notes

High availability is achieved through multiple cooperating mechanisms, not by an ALB alone.

1. **Multiple targets:** More than one application instance can serve requests.
2. **Multi-AZ placement:** Place the ALB and ASG across at least two Availability Zones.
3. **Health-aware routing:** Target Group health checks help the ALB avoid unhealthy targets.
4. **Capacity reconciliation:** The ASG attempts to maintain desired capacity.
5. **Repeatable replacement:** Launch Templates and AMIs help new instances start from a known configuration.

## Limitations

- A single-region architecture is not regional disaster recovery.
- An ALB cannot make a broken application healthy.
- An ASG cannot guarantee application correctness or data consistency.
- EBS snapshots do not replace database-native backups.
- A minimum capacity of two does not prove a 99.9% or 99.99% availability target.
- Dependencies such as DNS, databases, secrets, and external APIs can still be single points of failure.
