resource "aws_lb" "ecs_redis_serv" {
  name               = "${var.project_name}-redis-serv-alb"
  internal           = true
  load_balancer_type = "application"
 #  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [for subnet in aws_subnet.ecs_subnet : subnet.id]

  tags = {
    Name = "${var.project_name}-redis-serv-alb"
  }
}

resource "aws_lb_target_group" "ecs_redis_serv" {
  name     = "${var.project_name}-redis-serv-tg"
  port     = 6379
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecs_vpc.id
  target_type          = "ip"


  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_redist_serv" {
  load_balancer_arn = aws_lb.ecs_redis_serv.arn
  port              = 6379
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_redis_serv.arn
  }
}

