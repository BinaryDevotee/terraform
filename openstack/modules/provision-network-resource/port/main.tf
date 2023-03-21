resource "openstack_networking_port_v2" "port" {
  name           = "${var.port_name}"
  network_id     = "${var.network_id}"
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = "${var.subnet_id}"
    ip_address = "${var.port_ip_addr}"
  }
}
