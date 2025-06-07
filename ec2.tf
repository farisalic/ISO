resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
  vpc_id      = aws_vpc.main.id

  # SSH pristup
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ograničite na vaš IP za bezbednost
  }

  # Frontend port - dozvoliti samo sa ALB-a
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Backend port - dozvoliti samo sa ALB-a
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # PostgreSQL port - samo lokalno
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_ebs_volume" "db_data" {
  availability_zone = "us-east-1a"
  size              = 20  # Povećano sa 10GB
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${var.project_name}-db-data"
  }
}

resource "aws_instance" "app" {
  ami                         = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    git_repo_url = var.git_repo_url
  }))

  tags = {
    Name = "${var.project_name}-instance"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_volume_attachment" "db_attach" {
  device_name = "/dev/xvdf"  # Promenjeno sa /dev/sdf
  volume_id   = aws_ebs_volume.db_data.id
  instance_id = aws_instance.app.id
}