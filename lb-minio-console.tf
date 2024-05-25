
resource "aws_lb" "ecs_minio_con" {
  name               = "${var.project_name}-minio-con-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [for subnet in aws_subnet.ecs_subnet : subnet.id]

  tags = {
    Name = "${var.project_name}-minio-con-alb"
  }
}

resource "aws_lb_target_group" "ecs_minio_con" {
  name     = "${var.project_name}-minio-con-tg"
  port     = 9001
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

resource "aws_lb_listener" "front_minio_con" {
  load_balancer_arn = aws_lb.ecs_minio_con.arn
  port              = 9001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_minio_con.arn
  }
}

