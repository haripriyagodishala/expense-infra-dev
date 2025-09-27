resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("~/my-key.pub")
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = local.resource_name
  ami = data.aws_ami.openvpn_ami.id
  key_name = aws_key_pair.openvpn.key_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_id
  # user_data = file("openvpnas.sh")

  tags = merge(
    var.common_tags,
    var.vpn_tags,
    {
        Name = local.resource_name
    }
  )
}

# resource "aws_key_pair" "openvpn" {
#   key_name   = "openvpn"
#   public_key = file("~/my-key.pub") # for mac use /
# }

# resource "aws_instance" "vpn" {
#   ami           = "ami-06e5a963b2dadea6f"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = ["sg-0b620932ce14422f3"]
#   subnet_id = "subnet-03f6ff7aeba5af537"
#   key_name = aws_key_pair.openvpn.key_name
#   user_data = file("openvpnas.sh")

#   tags = {
#         Name = "expense-dev-vpn"
#     }
# }

# resource "aws_route53_record" "vpn" {
#   zone_id = var.zone_id
#   name    = "vpn-${var.environment}.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.vpn.public_ip]
#   allow_overwrite = true
# }