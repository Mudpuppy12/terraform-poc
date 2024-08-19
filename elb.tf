resource "aws_lb_target_group" "tg_group" {

  name        = "nginx-web"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = var.health_check["healthy_threshold"]
    interval            = var.health_check["interval"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
    timeout             = var.health_check["timeout"]
    path                = var.health_check["path"]
    port                = var.health_check["port"]
  }
}

variable "health_check" {
  type = map(string)
  default = {
    "timeout"             = "10"
    "interval"            = "20"
    "path"                = "/"
    "port"                = "80"
    "unhealthy_threshold" = "2"
    "healthy_threshold"   = "3"
  }
}

resource "aws_lb_target_group_attachment" "tg_attachments" {
  count            = length(aws_instance.hosts)
  target_group_arn = aws_lb_target_group.tg_group.arn
  target_id        = element(aws_instance.hosts[*].id, count.index)
  port             = 80
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_elb.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg_group.arn
    type             = "forward"
  }
}