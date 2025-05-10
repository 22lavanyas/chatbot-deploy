# 1. Create EC2 Instance in the Jenkins VPC, Jenkins Subnet
resource "aws_instance" "jenkins-server" {
  ami           = "ami-084568db4383264d4"   # The AMI ID you provided
  instance_type = "t2.2xlarge"               # EC2 instance type

  subnet_id = aws_subnet.public-subnet2.id      # Subnet ID for Jenkins subnet
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id] # Security Group for the instance
  
  associate_public_ip_address = true         # To allow the instance to have a public IP
  
  tags = {
    Name = "jenkins-server"
  }

  # Optionally, specify a key pair if you need SSH access
#   key_name = var.key_pair_name

  # Optional: add user data if you need to run startup scripts
  # user_data = file("setup.sh")
}

# 2. Jenkins Subnet Data Block (to reference subnet)
# data "aws_subnet" "jenkins" {
#   filter {
#     name   = "tag:Name"
#     values = ["jenkins-subnet"]   # Ensure this tag matches your subnet name
#   }
# }

# 3. Security Group for Jenkins Server
resource "aws_security_group" "jenkins-sg" {
  vpc_id = aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# 4. Reference Jenkins VPC (ensure it exists)
# data "aws_vpc" "jenkins-vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["jenkins-vpc"]  # Make sure this tag matches your VPC name
#   }
# }
