terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}
# Configure the AWS instance
resource "aws_instance" "web" {
  ami = "ami-06984ea821ac0a879"
  instance_type = "t2.medium"
  associate_public_ip_address=true
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  key_name = "amazonsecond-mumbai"  


  tags = {
    Name = "Jenkins-EKS-LaunchPad"
  }
}

resource "null_resource" "configure-consul-ips" {
  # Configure the file provisioner to copy the source file in current directory to remote directory 
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }
# Configure the remote-exec to run the scripts in remote machine 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_jenkins.sh",
      "/tmp/install_jenkins.sh",
    ]
  }

  connection {
    type         = "ssh"
    host         = aws_instance.web.public_ip
    user         = "ubuntu"
    private_key  = file("./amazonsecond-mumbai.pem" )
   }
}

data "aws_vpc" "default" {
  default = true
} 


# Configure another resource security groups
resource "aws_security_group" "jenkins-sg" {
  # Name, Description and the VPC of the Security Group
  name = "jenkins_sg"
  description = "Security group for jenkins server"
  vpc_id = data.aws_vpc.default.id

  # Since Jenkins runs on port 8080, we are allowing all traffic from the internet
  # to be able ot access the EC2 instance on port 8080
  ingress {
    description = "Allow Jenkins access from anywhere"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Since we only want to be able to SSH into the Jenkins EC2 instance, we are only
  # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH access from anywhere"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow http traffic from anywhere"
    from_port = "80"
    to_port = "80"
    protocol = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Allow http traffic from anywhere"
    from_port = "443"
    to_port = "443"
    protocol = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # We want the Jenkins EC2 instance to being able to talk to the internet
  egress {
    description = "Allow all outbound traffic"
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}









