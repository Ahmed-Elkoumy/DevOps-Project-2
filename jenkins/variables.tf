variable "vpc-cidr" {
  description = "vpc cidr"
  type        = string
}

variable "public_subnets" {
  description = "subnet cidr"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}