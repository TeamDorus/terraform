
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.7.3"
    }
    netbox = {
      source = "e-breuninger/netbox"
    }
  }
}



provider "proxmox" {
  pm_api_url = var.pve_api_url

  // Credentials are passed via environment variables

  // Terraform chokes on the Let's Encrypt certificate
  pm_tls_insecure = true
}


provider "netbox" {
  server_url           = var.netbox_api_url
  api_token            = var.netbox_api_token
  allow_insecure_https = true
}

