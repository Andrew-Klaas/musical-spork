#!/bin/bash
set -o xtrace
consul kv put -datacenter=us-east-1 service/profitapp/orange/fruit orange
