#!/usr/bin/env bash
set -x

# Centos7 Specific Setup Here
echo 'output: { all: "| tee -a /var/log/cloud-init-output.log" }' | sudo tee -a /etc/cloud/cloud.cfg.d/05_logging.cfg
