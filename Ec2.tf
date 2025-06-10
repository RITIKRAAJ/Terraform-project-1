# key pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-XXXXX1-key-ec2"
  public_key = file("XXXXX-key-ec2.pub")
  tags ={
    Environment =var.env
  }


}

# VPC & Security Group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-automate1-sg"
  description = "automate2-sg"
  vpc_id      = aws_default_vpc.default.id # interpolation is way in which you can inharite or extract the values from terraform block.
  #  ex-key = aws_key_pair.my_key.key_name

  # inbound rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "web app"
  }

  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # semantically equivalent to all ports
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  tags = {
    Name = "${var.env}-automate1-sg"
  }

}

# ec2 instance

resource "aws_instance" "my_instance" {
  # count= 2 # meta argument it use to create multiple arguments
  for_each =tomap({
     Rihax-automate-micro = "t2.micro",
     Rihax-automate-medium = "t2.micro",
    
  }) # meta argument
>
depends_on = [aws_security_group.my_security_group , aws_key_pair.my_key] # depends_on work.
# when security group is not created then how we will think to make instance --^
  ami             = var.ec2_ami_id # ubuntu
  instance_type   = each.value
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]

  user_data = file("install_nginx.sh")


  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
    Environment =var.env
  }
}

# this block is basically use for when you ec2 instaces is on aws but not in terraform then it will help you.
/*
resource "aws_instance" "my_new_instance" {      
      ami ="unknown"
      instance_type ="unknown"
  
} */
