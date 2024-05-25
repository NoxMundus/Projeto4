#nginx
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name        = "nginx"
      image       = "nginx:latest"
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.service_nginx}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_nginx.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.ecs_subnet : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_lb_listener.front_nginx
  ]
}


#projeto
resource "aws_ecs_task_definition" "projeto" {
  family                   = "projeto"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.projeto_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "rabbitmq"
      image       = "rabbitmq:3-management"
      essential   = true
      portMappings = [
        {
          name = "service_rabbit"
          containerPort = 5672
          protocol = "tcp"
        },
        {
          name = "console_rabbit" 
          containerPort = 15672
          protocol = "tcp"
        }
      ]
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "${aws_cloudwatch_log_group.log_ecs.name}"
          "awslogs-region": "${var.region}"
          "awslogs-stream-prefix": "ecs"
        }
      }
    },
    {
      name        = "redis"
      image       = "redis/redis-stack"
      essential   = false
      portMappings = [
        {
          name = "service_redis"
          containerPort = 6379
          hostPort = 6379
          protocol = "tcp"
        },
        {
          name = "console_redis" 
          containerPort = 8001
          hostPort = 8001
          protocol = "tcp"
        }
      ]
      environment= [
        {
          "name" : "REDIS_ARGS",
          "value" : "--save 60 1000 --appendonly yes"
        },
        {
          "name" : "REDISTIMESERIES_ARGS",
          "value" : "RETENTION_POLICY=20"
        }
      ]
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "${aws_cloudwatch_log_group.log_ecs.name}"
          "awslogs-region": "${var.region}"
          "awslogs-stream-prefix": "ecs"
        }
      }
    },
    {
      name        = "minio"
      image       = "quay.io/minio/minio"
      essential   = false
      command = ["server", "/data", "--console-address", ":9001"]
      portMappings = [
        {
          name = "service_minio"
          containerPort = 9000
          hostPort = 9000
          protocol = "tcp"
        },
        {
          name = "console_minio" 
          containerPort = 9001
          hostPort = 9001
          protocol = "tcp"
        }
      ]
      environment= [
        {
          "name" : "MINIO_ROOT_USER",
          "value" : "user"
        },
        {
          "name" : "MINIO_ROOT_PASSWORD",
          "value" : "password"
        }
      ]
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "${aws_cloudwatch_log_group.log_ecs.name}"
          "awslogs-region": "${var.region}"
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "rabbit_service_cont" {
  name            = "${var.service_rabbitmq}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.projeto.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_rabbit_con.arn
    container_name   = "rabbitmq"
    container_port   = 15672
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_rabbit_serv.arn
    container_name   = "rabbitmq"
    container_port   = 5672
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.ecs_subnet : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_lb_listener.front_rabbit_con
  ]
}

resource "aws_ecs_service" "redis_service_cont" {
  name            = "${var.service_redis}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.projeto.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_redis_con.arn
    container_name   = "redis"
    container_port   = 8001
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_redis_serv.arn
    container_name   = "redis"
    container_port   = 6379
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.ecs_subnet : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_lb_listener.front_redis_con
  ]
}

resource "aws_ecs_service" "minio_service_cont" {
  name            = "${var.service_minio}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.projeto.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_minio_con.arn
    container_name   = "minio"
    container_port   = 9001
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_minio_serv.arn
    container_name   = "minio"
    container_port   = 9000
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.ecs_subnet : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_lb_listener.front_minio_con
  ]
}


