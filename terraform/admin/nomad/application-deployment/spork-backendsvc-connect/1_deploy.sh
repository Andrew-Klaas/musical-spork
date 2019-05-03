#!/bin/bash
set -o xtrace
nomad job run spork-backendsvc-connect-us-east-1.hcl
nomad job run spork-backendsvc-connect-us-west-2.hcl
