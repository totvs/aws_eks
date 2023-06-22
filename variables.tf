variable "name" {
  description = ""
}

variable "role_arn" {
  description = ""
}

variable "k8s_version" {
  description = ""
}

variable "vpc_config" {
  description = ""
}

variable "nodegroup_list" {
  description = ""
}

variable "nodegroup_sg_ids" {
  description = "ID of created Nodegroups security group"  
}
