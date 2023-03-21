resource "openstack_networking_subnet_v2" "subnet" {
  name           = "${var.subnet_name}"
  cidr           = "${var.subnet_cidr}"
  ip_version     = "${var.subnet_ip_ver}"
  network_id     = "${var.network_id}"
}
