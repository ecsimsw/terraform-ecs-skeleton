resource "aws_key_pair" "ec2_monitoring_key" {
  key_name   = "monitoring-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ec2_monitoring_sg" {
  name   = "monitoring-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.medium"
  subnet_id              = var.subnet
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "cloud-monitoring"
  }
}

// ssh -i ~/.ssh/id_rsa ubuntu@43.203.128.140