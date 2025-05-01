# faz-IP
output "faz1_ip" {
  value = format("https://%s", google_compute_address.compute_address["faz1-static-ip"].address)
}

output "faz2_ip" {
  value = format("https://%s", google_compute_address.compute_address["faz2-static-ip"].address)
}

output "compute_addresses" {
  value = var.enable_output ? google_compute_address.compute_address : null
}

output "compute_networks" {
  value = var.enable_output ? google_compute_network.compute_network : null
}

output "compute_subnetworks" {
  value = var.enable_output ? google_compute_subnetwork.compute_subnetwork : null
}

output "compute_firewalls" {
  value = var.enable_output ? google_compute_firewall.compute_firewall : null
}

output "compute_disks" {
  value = var.enable_output ? google_compute_disk.compute_disk : null
}

output "compute_instances" {
  value     = var.enable_output ? google_compute_instance.compute_instance : null
  sensitive = true
}
