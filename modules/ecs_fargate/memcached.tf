# ==============================================
# TASK DEFINITION PARA MEMCACHED EN ECS FARGATE
# ==============================================
resource "aws_ecs_task_definition" "tasks" {
  for_each = var.services

  family                   = "${each.key}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.value.image
      cpu       = each.value.cpu
      memory    = each.value.memory
      essential = true
      portMappings = [
        {
          containerPort = 11211
          hostPort      = 11211
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_service_discovery_service" "services" {
  for_each = var.services

  name = each.key # Se registrará como "memcached.fargate.local"

  dns_config {
    namespace_id = var.service_discovery_namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


resource "aws_ecs_service" "services" {
  for_each = var.services

  name            = each.key
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.tasks[each.key].arn
  desired_count   = each.value.min_tasks
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.ecs_subnets
    security_groups  = [each.value.security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.services[each.key].arn # ✅ AHORA USAMOS EL SERVICE CORRECTO
  }
}
