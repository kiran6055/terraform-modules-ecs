resource "aws_ecs_cluster" "timing" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.timing.name
      }
    }
  }

}

resource "aws_cloudwatch_log_group" "timing" {
  name = var.ecs_log_group_name
    tags = merge(
    var.tags,
    var.ecs_cluster_tags
  )
}


resource "aws_ecs_cluster_capacity_providers" "timing" {
  cluster_name = aws_ecs_cluster.timing.name


  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    weight            = 50
    capacity_provider = "FARGATE_SPOT"
  }

  default_capacity_provider_strategy {
    weight            = 50
    capacity_provider = "FARGATE"
  }

}
