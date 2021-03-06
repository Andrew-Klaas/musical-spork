job "spork-backendsvc" {
  region      = "us-west-2"
  datacenters = ["us-west-2a", "us-west-2b", "us-west-2c"]
  type        = "service"
  priority    = 50
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }
  update {
    # Stagger updates every 10 seconds
    stagger = "10s"
    # Update a single task at a time
    max_parallel = 1
  }
  group "magenta" {
    count = 1
    restart {
      attempts = 2
      interval = "1m"
      delay    = "10s"
      mode     = "fail"
    }
    task "profitapp" {
      driver = "docker"
      config {
        image      = "arodd/spork-backendsvc:latest"
        force_pull = true
        port_map {
          http = 8080
        }
      }
      service {
        name = "profitapp"
        tags = ["profit", "${attr.consul.datacenter}", "${NOMAD_GROUP_NAME}", "${node.datacenter}"]
        port = "http"
      }
      resources {
        cpu    = 50
        memory = 128
        network {
          mbits = 1
          port  "http"{ static = 8081 }
        }
      }
      logs {
        max_files     = 10
        max_file_size = 15
      }
      template {
        data = <<EOH
KV_FRUIT="{{key "service/profitapp/magenta/fruit"}}"
EOH
        destination = "secrets/file.env"
        env         = true
      }
      vault {
        policies = ["vault-admin"]
      }
      kill_timeout = "1s"
    }
  }
  group "yellow" {
    count = 2
    restart {
      attempts = 2
      interval = "1m"
      delay    = "10s"
      mode     = "fail"
    }
    task "profitapp" {
      driver = "docker"
      config {
        image      = "arodd/spork-backendsvc:latest"
        force_pull = true
        port_map {
          http = 8080
        }
      }
      service {
        name = "profitapp"
        tags = ["profit", "${attr.consul.datacenter}", "${NOMAD_GROUP_NAME}", "${node.datacenter}"]
        port = "http"
      }
      resources {
        cpu    = 50
        memory = 128
        network {
          mbits = 1
          port  "http"{ static = 8081 }
        }
      }
      logs {
        max_files     = 10
        max_file_size = 15
      }
      template {
        data = <<EOH
KV_FRUIT="{{key "service/profitapp/yellow/fruit"}}"
EOH
        destination = "secrets/file.env"
        env         = true
      }
      vault {
        policies = ["vault-admin"]
      }
      kill_timeout = "1s"
    }
  }
}
