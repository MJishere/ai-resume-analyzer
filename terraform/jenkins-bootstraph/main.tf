# Fetch Latest Amazon Linux AMI id
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Security group for Jenkins Ec2 instance
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Security group for jenkins server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-sg"
  }
}

# Iam role for ec2
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-profile"
  role = aws_iam_role.jenkins_role.name
}

# Ec2 Instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  user_data = templatefile("${path.module}/user-data.tpl", {})

  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }
  tags = {
    Name = "jenkins_server"
  }
}

resource "aws_eip" "jenkins_eip" {
  instance   = aws_instance.jenkins_server.id
  depends_on = [aws_instance.jenkins_server]
}