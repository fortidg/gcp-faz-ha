variable "project" {}
variable "region" {}
variable "zone" {}
variable "zone2" {}

variable "prefix" {}

# fortianalyzers
variable "fortianalyzer_machine_type" {}
variable "fortianalyzer_vm_image" {}



# debug
variable "enable_output" {
  type        = bool
  default     = true
  description = "Debug"
}

