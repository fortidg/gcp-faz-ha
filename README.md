# GCP Active/Passive FortiAnalyzer

## How do you run these?

1. Log into GCP console and open a cloud shell.
1. use `git clone https://github.com/fortidg/gcp-fgt-a_a.git` to clone this repo.
1. Open `terraform.tfvars.example`Change the name to 'terraform.tfvars' update the required variables (project, region, zone zone2, prefix, fortigate_vm_image, fortigate_machine_type)   
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.

The prefix mentioned above is simply a memorable string of text to differentiate the resources deployed by this code.

There is no provision for cloudinit on FortiAnalyzer, so you will need to configure all of the required settings on FortiAnalyzer after creation.

[This](https://community.fortinet.com/t5/FortiAnalyzer/Technical-Tip-How-to-configure-FortiAnalyzer-HA-instance-in/ta-p/300170) link explains how to set up HA.
