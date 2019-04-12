resource "google_compute_instance" "mysql" {
  name         = "mysql"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  depends_on  = ["google_compute_instance.consul"]

  tags = ["consul-client"]

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
    source       = "${path.root}/run/mysql.sh"
    destination  = "/tmp/mysql.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /etc/consul.d && sudo mv available/retry-join-gce.json .",
      "chmod 0755 /tmp/*.sh",
      "sudo /tmp/mysql.sh"
    ]
  }
}
