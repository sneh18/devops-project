# Create ALB
resource "aws_alb" "alb" {  
  name            = "alb-183"
  subnets         = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  security_groups = [module.public-sg.security_group_id]
  internal  = false
  tags = {
    Terraform = "true"
  }
}

# Create simple ALB listener
resource "aws_alb_listener" "alb-listener" {  
  load_balancer_arn = "${aws_alb.alb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Listning on DevOps Project ALB"
      status_code  = "200"
    }
  }
}

# Create listener rule to forward /jenkins towards Jenkins instance
resource "aws_alb_listener_rule" "listener-rule-jenkins" {
  depends_on   = [aws_alb_target_group.jenkins-tg]  
  listener_arn = "${aws_alb_listener.alb-listener.arn}"  
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.jenkins-tg.id}"  
  }   
  condition {
    path_pattern {
      values = ["/jenkins/*","/jenkins"]
    }
  }
}

# Create listener rule to forward /app towards Application instance
resource "aws_alb_listener_rule" "listener_rule_app" {
  depends_on   = [aws_alb_target_group.app-tg]  
  listener_arn = "${aws_alb_listener.alb-listener.arn}"  
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.app-tg.id}"  
  }   
  condition {
    path_pattern {
      values = ["/app/*", "/app"]
    }
  }
}

# Create Jenkins Target group for Jenkins Instance
resource "aws_alb_target_group" "jenkins-tg" {  
  name     = "jenking-tg"  
  port     = "8080"  
  protocol = "HTTP"  
  vpc_id   = module.vpc.vpc_id  
  tags = {
    Terraform = "true"
  }
  health_check {
    path = "/jenkins"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200-499"  
  }
}

# Create Application Target Group for Application Instance
resource "aws_alb_target_group" "app-tg" {  
  name     = "app-tg"  
  port     = "8081"
  protocol = "HTTP"  
  vpc_id   = module.vpc.vpc_id  
  tags = {
    Terraform = "true"
  }
  health_check {
    path = "/app"
    port = 8081
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200-499"  
  }
}

# Attach Jenkins Instance to Jenkins Target group
resource "aws_lb_target_group_attachment" "jenkins" {
  depends_on   = [aws_alb_target_group.jenkins-tg]  
  target_group_arn = "${aws_alb_target_group.jenkins-tg.arn}"
  target_id        = module.jenkins-instance.id
  port             = "8080"
}

# Attach Application Instance to Application Target group
resource "aws_lb_target_group_attachment" "app" {
  depends_on   = [aws_alb_target_group.app-tg]  
  target_group_arn = "${aws_alb_target_group.app-tg.arn}"
  target_id        = module.app-instance.id
  port             = "8081"
}