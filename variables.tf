variable "vpc_id" {
  type = string
  description = "id of the vpc"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "ssh_user" {
  type = string
  description = "Name of the user"
}

variable "key_name" {
  type = string
  description = "Name of the key"
}

variable "ami_id" {
  type = string
  description = "ID of the AMI"
}

variable "instance_type" {
  type = string
  description = "Type of the instance"
}

variable "subnet" {
  type = string
  description = "subnet for ec2"
}

variable "private_key_path" {
  type = string
  description = "keyPath for the key"
}