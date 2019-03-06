job "transit-app-example" {
    datacenters = ["us-east-1a", "us-east-1b", "us-east-1c"]
    type = "service"
    update {
      max_parallel = 1
    }
    group "transit-app-example" {
        constraint {
            operator = "distinct_hosts"
            value = "true"
        }
        restart {
            attempts = 3
            delay = "5s"
	}
        count = 3
        task "transit-app-example" {

            driver = "docker"
            config {
                #image = "airedale/transit-demo:token"
                image = "aklaas2/transit-app-example-test:latest"
                volumes = ["local/config.ini:/usr/src/app/config/config.ini"]
                network_mode = "host"
                port_map {
                    transitApp = 5000
                }
            }
            template {
                data = <<EOH
                [DEFAULT]
                LogLevel = WARN
		
{{ with secret "lob_a/workshop/kv/transit-app-example"  }}
                [DATABASE]
                Address=db.service.consul
                Port=3306
                User={{ .Data.username }}
                Password={{ .Data.password }}
                Database=my_app
{{ end }}

                [VAULT]
                Enabled = True
                ProtectRecords=False
                Address=http://active.vault.service.consul:8200
                Token=
                KeyPath=lob_a/workshop/transit
                KeyName=customer-key
                DynamicDBCreds = false
                DynamicDBCredsPath = lob_a/workshop/database/creds/workshop-app
                EOH
                destination = "local/config.ini"
            }
            resources {
                cpu = 500
                memory = 1024
                network {
                    mbits = 10
                    port "transitApp" {
                        static = "5000"
                    }
                }
            }
            service {
                name = "transit-app-example"
                #tags = ["transit-app-example", "urlprefix-/transit-app-example/ strip=/transit-app-example/"]
		        tags = ["transit-app-example", "urlprefix-/"]

                port = "transitApp"
                check {
                    name = "alive"
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            vault {
              policies = ["transit-app-example"]
            }
        }
    }
}
