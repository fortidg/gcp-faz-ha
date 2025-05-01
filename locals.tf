locals {

  prefix = var.prefix

  region = var.region
  zone   = var.zone
  zone2  = var.zone2

  fortianalyzer_machine_type = var.fortianalyzer_machine_type
  fortianalyzer_vm_image     = var.fortianalyzer_vm_image

  
  #######################
  # Static IPs
  #######################

  compute_addresses = {
    "faz1-static-ip" = {
      region       = local.region
      name         = "${local.prefix}-faz1-static-ip-${random_string.string.result}"
      subnetwork   = null
      address      = null
      address_type = "EXTERNAL"
    }
    "faz2-static-ip" = {
      region       = local.region
      name         = "${local.prefix}-faz2-static-ip-${random_string.string.result}"
      subnetwork   = null
      address      = null
      address_type = "EXTERNAL"
    }
    "faz1-fazha-ip" = {
      region       = local.region
      name         = "${local.prefix}-faz1-fazha-ip-${random_string.string.result}"
      subnetwork   = google_compute_subnetwork.compute_subnetwork["fazha-subnet-1"].id
      address      = null
      address_type = "INTERNAL"
    }
    "faz2-fazha-ip" = {
      region       = local.region
      name         = "${local.prefix}-faz2-fazha-ip-${random_string.string.result}"
      subnetwork   = google_compute_subnetwork.compute_subnetwork["fazha-subnet-1"].id
      address      = null
      address_type = "INTERNAL"
    }
  }

  #######################
  # Compute Networks
  #######################

  compute_networks = {
    "fazha-vpc" = {
      region                  = local.region
      name                    = "${local.prefix}-fazha-vpc-${random_string.string.result}"
      auto_create_subnetworks = false
      routing_mode            = "REGIONAL"
    }
  }
  #######################
  # Compute Subnets
  #######################

  compute_subnetworks = {
    "fazha-subnet-1" = {
      region        = local.region
      network       = google_compute_network.compute_network["fazha-vpc"].id
      name          = "${local.prefix}-fazha-subnet-${random_string.string.result}"
      ip_cidr_range = "10.15.0.0/24"
      private_ip_google_access = "true"
    }
  }

  #######################
  # Compute Firewalls
  #######################

  compute_firewalls = {
    "fazha-internal" = {
      name               = "fazha-internal-${random_string.string.result}"
      network            = google_compute_network.compute_network["fazha-vpc"].name
      direction          = "INGRESS"
      source_ranges      = ["10.15.0.0/24"]
      destination_ranges = null
      allow = [{
        protocol = "all"
        ports    = null
      }]
    }
    "fazha-vpc-ingress" = {
      name               = "fazha-vpc-ingress-${random_string.string.result}"
      network            = google_compute_network.compute_network["fazha-vpc"].name
      direction          = "INGRESS"
      source_ranges      = ["0.0.0.0/0"]
      destination_ranges = null
      allow = [{
        protocol = "tcp"
        ports    = ["22", "80", "443", "514", "541", "3000"]
      }]
      target_tags = ["faz"]
    }
  }

  #######################
  # Compute disks
  #######################

compute_disks = {
  "faz1-logdisk" = {
    name = "faz1-logdisk-${random_string.string.result}"
    size = 300
    type = "pd-standard"
    zone = local.zone
  }
  "faz2-logdisk" = {
    name = "faz2-logdisk-${random_string.string.result}"
    size = 300
    type = "pd-standard"
    zone = local.zone2
  }
}

  #######################
  # Compute instances
  #######################

  compute_instances = {
    "faz1_instance" = {
      name         = "${local.prefix}-faz1-${random_string.string.result}"
      zone         = local.zone
      machine_type = local.fortianalyzer_machine_type

      can_ip_forward = "false"
      tags           = ["faz"]

      boot_disk_initialize_params_image = local.fortianalyzer_vm_image
      boot_disk_initialize_params_size = 500

      attached_disk = [{
        source = google_compute_disk.compute_disk["faz1-logdisk"].name
      }]

      network_interface = [{
        network    = google_compute_network.compute_network["fazha-vpc"].name
        subnetwork = google_compute_subnetwork.compute_subnetwork["fazha-subnet-1"].name
        network_ip = google_compute_address.compute_address["faz1-fazha-ip"].address
        access_config = [{
          nat_ip = google_compute_address.compute_address["faz1-static-ip"].address
        }]
      }]

      service_account_scopes    = ["cloud-platform"]
      allow_stopping_for_update = true
    }

    "faz2_instance" = {
      name         = "${local.prefix}-faz2-${random_string.string.result}"
      zone         = local.zone2
      machine_type = local.fortianalyzer_machine_type

      can_ip_forward = "false"
      tags           = ["faz"]

      boot_disk_initialize_params_image = local.fortianalyzer_vm_image
      boot_disk_initialize_params_size = 500

      attached_disk = [{
        source = google_compute_disk.compute_disk["faz2-logdisk"].name
      }]

      network_interface = [{
        network    = google_compute_network.compute_network["fazha-vpc"].name
        subnetwork = google_compute_subnetwork.compute_subnetwork["fazha-subnet-1"].name
        network_ip = google_compute_address.compute_address["faz2-fazha-ip"].address
        access_config = [{
          nat_ip = google_compute_address.compute_address["faz2-static-ip"].address
        }]
        }]

      service_account_scopes    = ["cloud-platform"]
      allow_stopping_for_update = true
    }
  }
}




