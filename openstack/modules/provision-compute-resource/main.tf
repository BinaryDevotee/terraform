resource "openstack_compute_instance_v2" "compute-resource" {
  for_each    = "${var.compute_resources}"

  name        = "${each.value.name}"
  flavor_name = "${each.value.flavor}"
  key_pair    = "${each.value.keypair}"
  image_id    = "${each.value.os_image}"

  security_groups = "${each.value.security_groups}"

  network {
    name = "${each.value.os_net_provider}"
  }
}
