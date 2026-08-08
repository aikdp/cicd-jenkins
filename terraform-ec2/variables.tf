#Subnet ID
variable "subnet_id" {
  type        = string
  default     = "subnet-0984c4f0a17f1f5e8"
  description = "Subnet ID"
}


#SG
variable "sg_id" {
  type = list(string)
  default = ["sg-0ac0a4d72dc0142f5"]
}



#Instance type
variable "instance_type" {
    default = {
      master = "t3.small"
      # agent = "c7i-flex.large"
    }
}

#Zone NAme
variable "domain_name" {
    default = "telugudevops.online"
}

variable "jenkins_agent" {
    default ="build-server"
}

variable "jenkins_server" {
    default ="jenkins-master"
}

variable "zone_id" {
    default = "Z050884235ML93UCDWTFX"
}

variable "common_tags" {
  type = map
  default = {
    Project     = "jenkins"
    Terraform   = "true"
    environment = "dev"
  }
}