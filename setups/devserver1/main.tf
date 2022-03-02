
variable "pve_api_url" {}
variable "netbox_api_url" {}
variable "netbox_api_token" {}
variable "vm_private_key_location" {}


module "devserver1" {
  // Mandatory parameters
  source                  = "../../modules/proxmox_lxc"
  pve_api_url             = var.pve_api_url // defined as TF_VAR_...
  netbox_api_url          = var.netbox_api_url
  netbox_api_token        = var.netbox_api_token
  vm_private_key_location = var.vm_private_key_location
  vm_hostname             = "devserver1"
  vm_role                 = "Server"
  vm_osplatform           = "Ubuntu 21.10 - impish"
  vm_ostemplate           = "ds218:vztmpl/ubuntu-21.10-standard_21.10-1_amd64.tar.zst"
  vm_tags                 = ["ubuntu_21_10_impish", "devsys"]
  vm_ssh_publickey        = <<-EOT
  ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAptygarYRdcrn4MB+ZMR4Ukaqr7+rMYIdYRhpp+bOI4Uhffo0Y5C05QKjHsWzGlfMdzxhaXwCnBQOCugzeBuV0VcBdeqbMiD8/5FQ81LzN+7ce2Rq7cnYWigKogJB5pNwVrrHSGHzJKJLCf6aPHCtaCpJ2TLnmooziYYTL1hN5c6RDC/zjJORyB0qBgiOk5t236Zyjf0s1LdlwCrDdzUPstOXMujVGrmmzCAbTH/OCNMLh1M5IZ9X/HxMpIIpPE7Cqa8NzMUlEX4mwCFHkbkoFG+gzghABL86sp0LPtNJ59RURh2tTJUAuiqA2iLfbdBajEIfVtX30c78T5BNwVFyAQ==
  EOT
  vm_network_ip           = "192.168.55.130/24"
  vm_network_gw           = "192.168.55.1"
  vm_unprivileged         = false

  // Optional parameters
  vm_memory      = 1024
  vm_rootfs_size = 16
}

