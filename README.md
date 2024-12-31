## Terraform / Spring boot / ECS
- AWS ECS IaC를 위한 Terraform 뼈대 코드

### Modules
- vpc
   - internet gateway
   - NAT gateway
   - public subnet, private subnet
   - route table
- service
   - ecs cluster, service, task
   - auto scale policy
   - cloud watch, log stream
   - container repository
- lb
   - application load balancer
   - security group
- events
   - sns
   - sqs

### Diagram