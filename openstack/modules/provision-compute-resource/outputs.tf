output "compute-resource-data" {
  value       = "${openstack_compute_instance_v2.compute-resource}"
  description = "Getting output data from my compute-instance"
}
