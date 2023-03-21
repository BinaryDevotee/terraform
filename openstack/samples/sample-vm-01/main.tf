##############################################################################
# SECURITY GROUPS
# Security groups are sets of IP filter rules that are applied to all
# project instances, which define networking access to the instance.

module "create--icmp-security-group" {
  source = "./modules/provision-security-group"

  sec_grp_name        = "vm-01-icmp-sec-group"
  sec_grp_desc        = "ICMP Security Group"
  sec_grp_from_port   = "-1"
  sec_grp_to_port     = "-1"
  sec_grp_ip_protocol = "icmp"
  sec_grp_cidr        = "0.0.0.0/0"
}

module "create--ssh-security-group" {
  source = "./modules/provision-security-group"

  sec_grp_name        = "vm-01-ssh-sec-group"
  sec_grp_desc        = "SSH Security Group"
  sec_grp_from_port   = "22"
  sec_grp_to_port     = "22"
  sec_grp_ip_protocol = "tcp"
  sec_grp_cidr        = "0.0.0.0/0"
}


##############################################################################
# NETWORK RESOURCES
# OpenStack Networking allows you to create and manage network objects, such
# as networks, subnets, and ports, which other OpenStack services can use.

module "create--vm-01-network" {
  source = "./modules/provision-network-resource/network"

  network_name = "vm-01-network"
}

module "create--vm-01-subnet" {
  source = "./modules/provision-network-resource/subnet"

  subnet_name   = "vm-01-subnet"
  subnet_cidr   = "192.168.0.0/24"
  subnet_ip_ver = "4"

  # specify the network information
  # that will host this subnet
  network_id    = "${module.create--vm-01-network.network-data.id}"
  network_name  = "${module.create--vm-01-network.network-data.name}"

  # this subnet *must* be created only after the
  # network has been created
  depends_on    = [
    module.create--vm-01-network
  ]
}

module "create--vm-01-port-01" {
  source = "./modules/provision-network-resource/port"

  port_name    = "vm-01-port-01"
  port_ip_addr = "192.168.0.11"

  # specify the network and subnet
  # information that will host this port
  network_id   = "${module.create--vm-01-network.network-data.id}"
  network_name = "${module.create--vm-01-network.network-data.name}"
  subnet_id    = "${module.create--vm-01-subnet.subnet-data.id}"
  subnet_name  = "${module.create--vm-01-subnet.subnet-data.name}"

  # this port *must* be created only after the
  # network and the subnet have been created
  depends_on = [
    module.create--vm-01-subnet
  ]
}


##############################################################################
# STORAGE RESOURCES
# This example provisions storage according to the following layout:

module "create--vm-01-data-storage" {
  source = "./modules/provision-block-storage"

  block_volumes = [
    {
      name        = "vm_01_data_100_01",
      size        = "100",
      volume_type = "ceph",
      description = "Data Storage for myapp",
    },
    {
      name        = "vm_01_data_100_02",
      size        = "100",
      volume_type = "ceph",
      description = "Data Storage for myapp",
    },
    {
      name        = "vm_01_data_100_03",
      size        = "100",
      volume_type = "ceph",
      description = "Data Storage for myapp",
    },
    {
      name        = "vm_01_data_100_04",
      size        = "100",
      volume_type = "ceph",
      description = "Data Storage for myapp",
    },
    {
      name        = "vm_01_data_100_05",
      size        = "100",
      volume_type = "ceph",
      description = "Data Storage for myapp",
    }
  ]
}

module "create--vm-01-log-storage" {
  source = "./modules/provision-block-storage"

  block_volumes = [
    {
      name        = "vm_01_log_200_01",
      size        = "200",
      volume_type = "ceph",
      description = "Log Storage for myapp",
    }
  ]
}

module "create--vm-01-cache-storage" {
  source = "./modules/provision-block-storage"

  block_volumes = [
    {
      name        = "vm_01_cache_064_01",
      size        = "64",
      volume_type = "ceph",
      description = "Cache Storage for myapp",
    },
    {
      name        = "vm_01_cache_064_02",
      size        = "64",
      volume_type = "ceph",
      description = "Cache Storage for myapp",
    }
  ]
}

module "create--vm-01-tmp-storage" {
  source = "./modules/provision-block-storage"

  block_volumes = [
    {
      name        = "vm_01_tmp_500_01",
      size        = "500",
      volume_type = "ceph",
      description = "Temporary Storage for myapp",
    }
  ]
}


##############################################################################
# COMPUTE RESOURCES
# The OpenStack Compute service allows you to control an
# Infrastructure-as-a-Service (IaaS) cloud computing platform.

module "create--compute-resources" {
  source = "./modules/provision-compute-resource"

  compute_resources = {
    sample-vm-01-a = {

      # compute resource specifications
      name            = "sample-vm-01-a",
      os_image        = "31204290-8e4f-4929-8a97-0e016fff5e59",
      flavor          = "m1.xlarge",
      keypair         = "atrodrig",
      os_net_provider = "provider_net_shared_3",
    
      # define which security groups
      # will be attached to the instance
      security_groups = [
        "${module.create--icmp-security-group.security-group-data.name}",
        "${module.create--ssh-security-group.security-group-data.name}",
      ]
    
      # provisioning a compute instance depends on having other
      # pre-requisite resources readily available to avoid running
      # into a race condition when spinning up this resource
      depends_on = [

        # security groups
        module.create--icmp-security-group,
        module.create--ssh-security-group,
    
        # network stack
        module.create--vm-01-network,
        module.create--vm-01-subnet,
        module.create--vm-01-port-01,
    
        # storage stack
        module.create--vm-01-data-storage,
        module.create--vm-01-log-storage,
        module.create--vm-01-cache-storage,
        module.create--vm-01-tmp-storage,

      ]
    }
  }
}


##############################################################################
# ATTACHMENTS
# This example attaches an existing network to an existing compute resource

resource "openstack_compute_interface_attach_v2" "attach-network" {
  instance_id = "${module.create--compute-resources.compute-resource-data.sample-vm-01-a.id}"
  network_id  = "${module.create--vm-01-network.network-data.id}"

  depends_on = [
    module.create--compute-resources,
  ]
}

resource "openstack_compute_volume_attach_v2" "attach-data-storage" {
  count       = "5"
  instance_id = "${module.create--compute-resources.compute-resource-data.sample-vm-01-a.id}"
  volume_id   = "${module.create--vm-01-data-storage.block-storage-data.*.id[count.index]}"

  depends_on = [
    module.create--compute-resources,
  ]
}

resource "openstack_compute_volume_attach_v2" "attach-log-storage" {
  count       = "1"
  instance_id = "${module.create--compute-resources.compute-resource-data.sample-vm-01-a.id}"
  volume_id   = "${module.create--vm-01-log-storage.block-storage-data.*.id[count.index]}"

  depends_on = [
    module.create--compute-resources,
  ]
}

resource "openstack_compute_volume_attach_v2" "attach-cache-storage" {
  count       = "2"
  instance_id = "${module.create--compute-resources.compute-resource-data.sample-vm-01-a.id}"
  volume_id   = "${module.create--vm-01-cache-storage.block-storage-data.*.id[count.index]}"

  depends_on = [
    module.create--compute-resources,
  ]
}

resource "openstack_compute_volume_attach_v2" "attach-tmp-storage" {
  count       = "1"
  instance_id = "${module.create--compute-resources.compute-resource-data.sample-vm-01-a.id}"
  volume_id   = "${module.create--vm-01-tmp-storage.block-storage-data.*.id[count.index]}"

  depends_on = [
    module.create--compute-resources,
  ]
}
