variable "compute_resources" {
  type = map(object({
    name            = string,
    os_image        = string,
    flavor          = string,
    keypair         = string,
    os_net_provider = string,
    security_groups = list(string),
  }))
}
