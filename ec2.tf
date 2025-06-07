resource "aws_security_group" "ec2_sg" {
  name   = "ec2_sg"
  vpc_id = aws_vpc.main.id

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

resource "aws_ebs_volume" "db_data" {
  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"
  tags = {
    Name = "notes-db-data"
  }
}

resource "aws_instance" "app" {
  ami                         = "ami-0c2b8ca1dad447f8a" # Ubuntu 22.04 LTS (provjeriti)
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project_name}-instance"
  }

  root_block_device {
    volume_size = 10
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_volume_attachment" "db_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.db_data.id
  instance_id = aws_instance.app.id
  force_detach = true
}
