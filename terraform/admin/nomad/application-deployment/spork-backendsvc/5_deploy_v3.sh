#!/bin/bash
set -o xtrace
nomad job run spork-backendsvc-us-east-1-v3.hcl
nomad job run spork-backendsvc-us-west-2-v3.hcl
