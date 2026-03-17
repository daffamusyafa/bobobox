# 1. Membuat VPC (Virtual Private Cloud)
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "bobobox-vpc"
  }
}

# 2. Membuat Internet Gateway agar VM punya akses internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# 3. Membuat Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# 4. Membuat Firewall (Security Group)
resource "aws_security_group" "web_sg" {
  name        = "allow-web-traffic"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main_vpc.id

  # Inbound HTTP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound All (Agar server bisa download package)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Membuat EC2 Instance (VM)
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Menjalankan startup script
  user_data = file("./scripts/setup.sh")

  tags = {
    Name = "Bobobox-Web-Server"
  }
}
