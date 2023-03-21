##############################################################################
# SUBNET RESOURCES VARIABLES
# Describe it here

variable "network_id" {
  description = "Network ID"
  type        = string
}

variable "network_name" {
  description = "Network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR Notation"
  type        = string
}

variable "subnet_ip_ver" {
  description = "Subnet IP protocol: 4, 6"
  type        = string
}
