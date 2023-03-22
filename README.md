## Terraform

In this repository you will find a small collection of Terraform modules and samples to manage the most common OpenStack resources, such as compute, storage, and network.

While this is not a comprehensive list, this should help you to bootstrap a fairly complex infrastructure in a cleaner way. Refer to the 'samples' directory for a few examples on how this can be achieved.

## Pre-requisites

In order to use these resources some familiarity with authenticating to OpenStack is required. You must be authenticated to the desired cloud to manipulate resources. The easiest way to do this is to use the `clouds.yaml` file. This file should contain your cloud(s) definition so that you can instantiate them in the `provider.tf` file.

## Motivation

I wanted to share these modules and a few examples as most of the Terraform related materials and examples online target AWS instead of OpenStack, and I thought that this could benefit someone. Additionally, I wanted to explore Terraform modules a little bit in order to make my code as reusable as possible.

During this experimentation phase, I played a bit with complex variables such as maps and lists to spin up my resources and I deployed those into my modules where I thought it made sense. This helped me to better understand how to leverage these variables for more complex use cases in a way to reduce the amount of code duplication and API calls to get where I wanted.

## Rationale

As an exampe to what I mean above, you will notice that the `provision-block-storage` module uses a list of objects that can be created as follows:

```
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
```

This should help reduce the amount of API calls made against OpenStack to create two (or more) volumes.

The same applies for the `provision-compute-resources` module. Here, I am using a map of objects instead. Refer to the samples for examples on how this data structure can be used.

Why? As I mentioned above, purely for experimentation purposes.

A question may arise as in why to use these complex variables to spin one or two compute resources and potentially a handful of other resources. Well, as ointed out previously, I wanted to experient with more advanced data types not only to make my code cleaner, but also to make it more efficient and scalable. If I can call a module once to provision 50 storage volumes, I would prefer than calling the same module 50 times. This can only be achieved if my data type allows me to do so.

Also, in some cases, I noticed that I made my life a little bit easier while manipulating attachments.

## Code structure

I am mostly familiar with Ansible instead of Terraform, therefore, I wanted to explore what the Terraform modules could do for me, and I realized that I can roughly compare them to Ansible modules. As a consequence, I wanted to write my automation reusing these resources as much as possible and preferably without defining my *resources* in the `main.tf` file.

You will notice that my `sample-vm-01` has pretty much no resource definition in the `main.tf` file, except for the attachments as there seems to be no other way to move the modules. I could obviously move those to a separate file, but I am trying to stick to the default and well known Terraform files.

Finally, I am trying to follow Terraform best practices as much as I can, but some of them might not make sense to me, so I am obviously writing a clean code that ultimately makes sense to me.

Hopefully these resources will help you to manipulate your resources on OpenStack too. Feel free to contribute to this repo or suggest any correction or improvement to the current materials.

## Project layout

The samples should be able to reach the contents of the `modules` directory, therefore, they are a symbolic link to that directory.
Here's the complete directory structure:

```
.
└── openstack
    ├── modules
    │   ├── provision-block-storage
    │   ├── provision-compute-resource
    │   ├── provision-network-resource
    │   │   ├── network
    │   │   ├── port
    │   │   └── subnet
    │   └── provision-security-group
    └── samples
        └── sample-vm-01
            └── modules -> ../../modules
```

## License

Distributed under the Apache License 2.0. See LICENSE.txt for more information.
