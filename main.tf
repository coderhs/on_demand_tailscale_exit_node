terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.25"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "digitalocean_token" {
  description = "DigitalOcean API Token"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale Auth Key"
  type        = string
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint added to your DigitalOcean account"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to your SSH private key"
  type        = string
}

resource "digitalocean_droplet" "tailscale_exit_node" {
  name   = "tailscale-exit-node"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  region = "nyc3"
  ssh_keys = [var.ssh_fingerprint]
  user_data = <<EOF
  #cloud-config
  runcmd:
    - apt-get update
    - apt-get install -y curl
    - curl -fsSL https://tailscale.com/install.sh | sh
    - echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    - echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    - sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
    - tailscale up --authkey=${var.tailscale_auth_key}  --advertise-exit-node
  EOF

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = self.ipv4_address
  }
}

