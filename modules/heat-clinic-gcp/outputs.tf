output "vault_root_token" {
    value = "${trimspace(file("/tmp/root-token.txt"))}"
    description = "Root token for authenticating to Vault"
    depends_on = [
        "google_compute_instance.consul"
    ]
}

output "vault_unseal_key" {
    value = "${trimspace(file("/tmp/unseal-key.txt"))}"
    description = "Operator key for unsealing Vault"
    depends_on = [
        "google_compute_instance.consul"
    ]
}

output "nginx_ip_address" {
    value = "${google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip}"
    description = "Public IP address of the web server"
}

output "consul_ip_address" {
    value = "${google_compute_instance.consul.network_interface.0.access_config.0.nat_ip}"
    description = "Public IP address of the Consul server"
}

output "app_url" {
    value = "https://${google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip}/"
    description = "URL for the Heat Clinic site"
}

output "admin_url" {
    value = "https://${google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip}/admin/"
    description = "URL for the Heat Clinic admin site"
}

output "consul_url" {
    value = "http://${google_compute_instance.consul.network_interface.0.access_config.0.nat_ip}:8500/"
    description = "URL for the Consul UI"
}
