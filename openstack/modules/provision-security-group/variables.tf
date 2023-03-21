variable "sec_grp_name" {
  description = "Security Group name"
  type        = string
}

variable "sec_grp_desc" {
  description = "Security Group description"
  type        = string
}

variable "sec_grp_from_port" {
  description = "Source traffic port"
  type        = string
}

variable "sec_grp_to_port" {
  description = "Destination traffic port"
  type        = string
}

variable "sec_grp_ip_protocol" {
  description = "Protocol (icmp, tcp, udp)"
  type        = string
}

variable "sec_grp_cidr" {
  description = "CIDR Notation"
  type        = string
}
