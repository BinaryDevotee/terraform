resource "openstack_networking_network_v2" "network" {
  name           = "${var.network_name}"
  admin_state_up = "true"
}
