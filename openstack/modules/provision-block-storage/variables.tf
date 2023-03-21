variable "block_volumes" {
  type = list(object({
    name        = string,
    size        = number,
    volume_type = string,
    description = string,
  }))
}
