variable "project_name" {
    type        = "string"
    default     = "heat-clinic-demo"
    description = "Name of the GCP project to create resources in."
}

variable "region" {
    type        = "string"
    default     = "us-east1"
    description = "GCP region to create resources in."
}

variable "zone" {
    type        = "string"
    default     = "us-east1-c"
    description = "GCP zone to create resources in."
}

variable "machine_type" {
    type        = "string"
    default     = "g1-small"
    description = "Machine type to use."
}

module "gcp" {
    source       = "./modules/heat-clinic-gcp"
    project_name = "${var.project_name}"
    region       = "${var.region}"
    zone         = "${var.zone}"
    machine_type = "${var.machine_type}"
}
