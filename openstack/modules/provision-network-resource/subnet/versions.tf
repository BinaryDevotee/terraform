##############################################################################
# PROVIDER INFORMATION
# The OpenStack provider is used to interact with the many resources
# supported by OpenStack. The provider needs to be configured with the
# proper credentials before it can be used.

terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
