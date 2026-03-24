resource "tailscale_tailnet_key" "aws_web_key" {
  reusable      = false
  ephemeral     = true
  preauthorized = true
  expiry        = 3600
  tags          = ["tag:webserver"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allows HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = templatefile("${path.module}/scripts/setup.sh", {
    TS_KEY          = tailscale_tailnet_key.aws_web_key.key
    DB_HOST         = "db-server"
    DB_NAME         = var.db_name
    DB_USER         = var.db_user
    DB_PASS         = var.db_password
    SSH_PRIVATE_KEY = var.ssh_private_key
  })

  tags = { Name = "Hybrid-Webserver" }
}
