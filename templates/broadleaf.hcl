consul {
  address = "127.0.0.1:8500"
}

vault {
  address = "http://${vault_ip}:8200"
  token = "${root_token}"
  renew_token = false
}

template {
  source = "/etc/consul-template/templates/common-shared.properties.ctmpl"
  destination = "/opt/DemoSite/core/src/main/resources/runtime-properties/common-shared.properties"
}

log_level = "debug"
