
variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_default_root_storage_size" {
  default = 10
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-084568db4383264d4"
  type    = string

}

variable "env"{
  default ="dev" # if we use "prd" it switch to the 20GB
  type = string
}
