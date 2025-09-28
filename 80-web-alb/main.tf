module "web_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false
  name    = "${local.resource_name}-web-alb" #expense-dev-web-alb
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  security_groups = [data.aws_ssm_parameter.web_alb_sg_id.value]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    var.web_alb_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Web ALB Listener HTTP</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Web ALB listener HTTPS rule</h1>"
      status_code  = "200"
    }
  }
}


# module "records" {
#   source  = "terraform-aws-modules/route53/aws"

#   name = var.zone_name #haridevops.space
#   #zone_name = var.zone_name #haridevops.space -- previously it was zone_name input in the module
#   #Now it got changed to only name field on left side
#   #refer the root module for more information

#   records = {
#     "name" = {
#       name    = "expense-${var.environment}" # expense-dev
#       type    = "A"
#       alias   = {
#         name    = module.web_alb.dns_name
#         zone_id = module.web_alb.zone_id # This belongs ALB internal hosted zone, not ours
#       }
#       allow_overwrite = true
#   }
#   }
# }

resource "aws_route53_record" "web_alb_r53" {
  zone_id = var.zone_id
  name    = "expense-${var.environment}.${var.zone_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = module.web_alb.dns_name
    zone_id                = module.web_alb.zone_id
    evaluate_target_health = true
  }
}