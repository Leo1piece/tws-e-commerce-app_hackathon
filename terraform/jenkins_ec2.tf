data "aws_ami" "os_image" {
  owners      = ["099720109477"]  # Ubuntu 官方账户 ID 
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
  }
}
# 需要生成一个密钥对 priveate key in your local machine and public key upload terraform 
resource "aws_key_pair" "deployer" {
  key_name   = "terra-automate-key"
  public_key = file("terra-key.pub")
}

resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow TLS"
  description = "Allow user to connect"
  vpc_id      = module.vpc.vpc_id

  #dynamic  dynamic 语法是专门用来 生成子块 (nested block) 的。 aws_security_group.ingress → nested block → 要用 dynamic

# aws_iam_role_policy_attachment → 独立资源 → 直接 for_each
  #  dynamic "ingress" 简化了配置（循环生成多个 ingress 规则）。 dynamic "ebs_block_device" {
  # 或者     role_policy attachment 中可以使用  for_each   = toset(var.policy_arns)    policy_arn = each.value
  dynamic "ingress" {  
    for_each = [
      { description = "port 22 allow", from = 22, to = 22, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "port 80 allow", from = 80, to = 80, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "port 443 allow", from = 443, to = 443, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "port 8080 allow", from = 8080, to = 8080, protocol = "tcp", cidr = ["0.0.0.0/0"] }
    ]
    content {
      description = ingress.value.descriptionv
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "testinstance" {
  ami                    = data.aws_ami.os_image.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("${path.module}/install_tools.sh")
  tags = {
    Name = "Jenkins-Automate"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

}

resource "aws_eip" "jenkins_server_ip" {
  instance = aws_instance.testinstance.id
  domain   = "vpc"
}