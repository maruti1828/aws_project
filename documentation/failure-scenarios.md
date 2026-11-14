# Failure scenarios and validation plan

Do not mark a scenario as tested until you have performed it and captured evidence.

| Scenario | Expected behavior | Evidence to capture |
|---|---|---|
| Terminate one ASG instance | ASG launches replacement to restore desired capacity | ASG activity history and instance list |
| Application endpoint fails health check | Target Group marks target unhealthy and ALB stops routing new requests to it | Target health view and health-check settings |
| Increase request load | Configured scaling policy may increase desired capacity up to max 3 | CloudWatch metric, scaling activity, instance count |
| Change Launch Template version | New launches use selected template version; existing instances need refresh/replacement | Launch Template versions and ASG configuration |
| Restore EBS snapshot | A new volume can be created from snapshot and validated | Snapshot, restored volume, recovery test |

## Safe testing

- Use a non-production environment.
- Confirm the ASG is managing the instance before terminating it.
- Do not delete volumes or snapshots containing data you need.
- Watch ASG activity and Target Group health while testing.
- Record timestamps and screenshots.
- Clean up test resources after validation.
