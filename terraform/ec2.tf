# latest ami-id filter
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# key-pair
resource "aws_key_pair" "key-pair" {
  key_name   = "key-pair"
  public_key = file("terra-key.pub")
}

# vpc default
resource "aws_default_vpc" "default" {

}

# sg group
resource "aws_security_group" "security_group" {
  name        = "security_group"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins"
  }

  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins Email"
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Sonar"
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NodePort"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Access for all"
  }

  tags = {
    Name = "security_group"
  }
}

# aws ec2
resource "aws_instance" "ecommerce_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.aws_instance_type
  key_name        = aws_key_pair.key-pair.key_name
  security_groups = [aws_security_group.security_group.name]
  depends_on      = [aws_default_vpc.default, aws_key_pair.key-pair]
  user_data = file("${path.module}/install_tools.sh")   #Look for the file right here in the same folder as this code.

  root_block_device {
    volume_size = var.aws_root_volume_size
    volume_type = var.aws_root_volume_type
  }
  
  tags = {
    Name        = var.aws_instance_name
    Environment = var.env
  }
}

