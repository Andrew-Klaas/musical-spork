#!/bin/bash
set -o xtrace
consul kv put -datacenter=us-east-1 service/web/debug True
consul kv put -datacenter=us-west-2 service/web/debug True
