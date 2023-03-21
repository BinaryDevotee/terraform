output "block-storage-data" {
  value       = "${openstack_blockstorage_volume_v3.block-storage}"
  description = "Getting output data from my block storage"
}
