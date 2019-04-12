resource "google_compute_instance" "consul" {
  name         = "consul${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  count        = 1

  tags = ["consul-server"]

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
    source       = "${path.root}/run/consul.sh"
    destination  = "/tmp/consul.sh"
  }

  provisioner "file" {
    source      = "${path.root}/run/vault.sh"
    destination = "/tmp/vault.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /etc/consul.d && sudo mv available/retry-join-gce.json .",
      "chmod 0755 /tmp/*.sh",
      "sudo /tmp/consul.sh",
      "sudo /tmp/vault.sh"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${path.root}/files/ssh/id_ecdsa demo@${google_compute_instance.consul.network_interface.0.access_config.0.nat_ip}:/etc/vault/*.txt /tmp"
  }
}
