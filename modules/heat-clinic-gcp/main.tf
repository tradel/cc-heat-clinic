provider "google" {
  project = "${var.project_name}"
  region  = "${var.region}"
  version = "~> 2.3"
}

data "google_compute_image" "heat_clinic_image" {
  family = "heat-clinic"
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "nginx" {
  name    = "allow-https-nginx"
  network = "${data.google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["nginx"]
}

resource "google_compute_firewall" "consul" {
  name    = "allow-consul-8500"
  network = "${data.google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["8500"]
  }

  target_tags = ["consul-server"]
}

