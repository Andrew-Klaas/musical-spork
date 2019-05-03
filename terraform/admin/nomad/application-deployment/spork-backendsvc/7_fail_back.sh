#!/bin/bash
set -o xtrace
nomad job run spork-backendsvc-us-east-1-v3.hcl
