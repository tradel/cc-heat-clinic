provider "consul" {
  address    = "http://${google_compute_instance.consul.network_interface.0.access_config.0.nat_ip}:8500"
  datacenter = "dc1"
  version    = "~> 2.3"
}

# resource "consul_intention" "default_deny" {
#   source_name      = "*"
#   destination_name = "*"
#   action           = "deny"
#   depends_on       = ["google_compute_instance.consul"]
# }

# resource "consul_intention" "allow_web_app" {
#   source_name      = "web"
#   destination_name = "app"
#   action           = "allow"
#   depends_on       = ["google_compute_instance.consul"]
# }

# resource "consul_intention" "allow_web_admin" {
#   source_name      = "web"
#   destination_name = "admin"
#   action           = "allow"
#   depends_on       = ["google_compute_instance.consul"]
# }

# resource "consul_intention" "allow_app_db" {
#   source_name      = "app"
#   destination_name = "db"
#   action           = "allow"
#   depends_on       = ["google_compute_instance.consul"]
# }

# resource "consul_intention" "allow_admin_db" {
#   source_name      = "admin"
#   destination_name = "db"
#   action           = "allow"
#   depends_on       = ["google_compute_instance.consul"]
# }

