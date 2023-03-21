resource "openstack_blockstorage_volume_v3" "block-storage" {
  count       = "${length(var.block_volumes)}"

  name        = "${var.block_volumes[count.index].name}"
  size        = "${var.block_volumes[count.index].size}"
  volume_type = "${var.block_volumes[count.index].volume_type}"
  description = "${var.block_volumes[count.index].description}"
}
