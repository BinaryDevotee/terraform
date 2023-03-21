##############################################################################
# NETWORK RESOURCES VARIABLES

variable "network_id" {
  description = "Network ID"
  type        = string
}

variable "network_name" {
  description = "Network name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "port_name" {
  description = "Port name"
  type        = string
}

variable "port_ip_addr" {
  description = "IP address of the port"
  type        = string
}
