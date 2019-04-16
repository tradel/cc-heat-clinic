resource "google_compute_instance" "site" {
  name         = "site${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  count        = 1
  depends_on  = ["google_compute_instance.consul", "google_compute_instance.mysql"]

  tags = ["consul-client", "broadleaf-site"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.heat_clinic_image.self_link}"
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  connection {
    type        = "ssh"
    user        = "demo"
    agent       = false 
    private_key = "${file("${path.root}/files/ssh/id_ecdsa")}"
  }

  provisioner "file" {
    source       = "${path.root}/run/site.sh"
    destination  = "/tmp/site.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /etc/consul.d && sudo mv available/retry-join-gce.json .",
      "chmod 0755 /tmp/*.sh",
      "sudo VAULT_IP=${google_compute_instance.consul.network_interface.0.network_ip} VAULT_TOKEN=${trimspace(file("/tmp/root-token.txt"))} /tmp/site.sh"
    ]
  }
}
