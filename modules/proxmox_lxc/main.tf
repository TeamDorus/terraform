

locals {
  proxmox_vmid   = proxmox_lxc.lxc.id
  netbox_vmid    = netbox_virtual_machine.vm.id
  vm_network_mac = proxmox_lxc.lxc.network[0].hwaddr
}


// --------------------------------------------------------------------------
//
//    VM resource definition for Proxmox
//
// --------------------------------------------------------------------------


resource "proxmox_lxc" "lxc" {
  target_node     = var.pve_target_node
  hostname        = var.vm_hostname
  ostemplate      = var.vm_ostemplate
  ssh_public_keys = var.vm_ssh_publickey
  unprivileged    = var.vm_unprivileged
  onboot          = var.vm_onboot
  start           = var.vm_start
  cores           = var.vm_cores
  memory          = var.vm_memory

  rootfs {
    storage = var.vm_rootfs_storage
    size    = "${var.vm_rootfs_size}G"
  }

  network {
    name   = var.vm_network_name
    bridge = var.vm_network_bridge
    ip     = var.vm_network_ip
    gw     = var.vm_network_gw
  }

  features {
    nesting = var.vm_features_nesting
    mount   = var.vm_features_mount
  }

  // Wait for VM to start up before starting the ansible script
  provisioner "remote-exec" {
    inline = ["echo Container is up-and-running!"]
    connection {
      host        = split("/", self.network[0].ip)[0]
      type        = "ssh"
      user        = "root"
      private_key = file(var.vm_private_key_location)
    }
  }

  // Execute ansible playbook to initialize the VM
  provisioner "local-exec" {
    command     = "ansible-playbook -K lxc_init.yml -i '${split("/", self.network[0].ip)[0]},'"
    working_dir = "../../../ansible"
  }

  // @Destroy: run playbook to remove configs for this VM in other servers
  provisioner "local-exec" {
    command     = "ansible-playbook lxc_destroy.yml -i '${split("/", self.network[0].ip)[0]},'"
    working_dir = "../../../ansible"
    when        = destroy
  }
}


// --------------------------------------------------------------------------
//
//    VM definition resource definitions for Netbox
//
// --------------------------------------------------------------------------

data "netbox_device_role" "role" {
  name = var.vm_role
}

data "netbox_cluster" "cluster" {
  name = var.pve_target_node
}

data "netbox_platform" "os_platform" {
  name = var.vm_osplatform
}


resource "netbox_virtual_machine" "vm" {
  cluster_id   = data.netbox_cluster.cluster.id
  name         = var.vm_hostname
  disk_size_gb = var.vm_rootfs_size
  memory_mb    = var.vm_memory
  vcpus        = var.vm_cores
  role_id      = data.netbox_device_role.role.id
  platform_id  = data.netbox_platform.os_platform.id
  tags         = var.vm_tags
  comments     = local.proxmox_vmid
}


resource "netbox_interface" "interface" {
  name               = var.vm_network_name
  virtual_machine_id = local.netbox_vmid
  mac_address        = local.vm_network_mac
}


resource "netbox_ip_address" "ip_addr" {
  ip_address   = var.vm_network_ip
  dns_name     = var.vm_hostname
  status       = "active"
  interface_id = netbox_interface.interface.id
}


resource "netbox_primary_ip" "primary_ip" {
  ip_address_id      = netbox_ip_address.ip_addr.id
  virtual_machine_id = local.netbox_vmid
}

resource "netbox_service" "service" {
    name               = "ssh"
    ports              = [22]
    protocol           = "tcp"
    virtual_machine_id = local.netbox_vmid
}
