resource "openstack_compute_secgroup_v2" "security-group" {
  name          = "${var.sec_grp_name}"
  description   = "${var.sec_grp_desc}"

  rule {
    from_port   = "${var.sec_grp_from_port}"
    to_port     = "${var.sec_grp_to_port}"
    ip_protocol = "${var.sec_grp_ip_protocol}"
    cidr        = "${var.sec_grp_cidr}"
  }
}
