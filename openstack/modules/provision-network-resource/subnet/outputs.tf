output "subnet-data" {
  value       = "${openstack_networking_subnet_v2.subnet}"
  description = "Getting output data from my subnet"
}
