// --------------------------------------------------------------------------
//
//    Variables for Proxmox LXC module
//
// --------------------------------------------------------------------------

variable "pve_api_url" {
  type = string
}


variable "netbox_api_url" {
  type = string
}
variable "netbox_api_token" {
  type = string
}


variable "vm_private_key_location" {
  type = string
}


variable "pve_target_node" {
  type    = string
  default = "hm80"
}
variable "vm_hostname" {
  type = string
}
variable "vm_osplatform" {
  type = string
}
variable "vm_ostemplate" {
  type = string
}
variable "vm_tags" {
  type = set(string)
}
variable "vm_ssh_publickey" {
  type = string
}
variable "vm_unprivileged" {
  type    = bool
  default = true
}
variable "vm_onboot" {
  type    = bool
  default = true
}
variable "vm_start" {
  type    = bool
  default = true
}
variable "vm_cores" {
  type    = number
  default = 1
}
variable "vm_memory" {
  type    = number
  default = 512
}
variable "vm_rootfs_storage" {
  type    = string
  default = "local-zfs"
}
variable "vm_rootfs_size" {
  type    = number
  default = 8
}
variable "vm_network_name" {
  type    = string
  default = "eth0"
}
variable "vm_network_bridge" {
  type    = string
  default = "vmbr0"
}
variable "vm_network_ip" {
  type = string
}
variable "vm_network_gw" {
  type = string
}
variable "vm_features_nesting" {
  type    = bool
  default = false
}
variable "vm_features_mount" {
  type    = string
  default = ""
}
variable "vm_role" {
  type = string
}

