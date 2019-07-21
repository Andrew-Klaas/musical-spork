#!/bin/bash
set -o xtrace
nomad job stop -purge -region us-east-1 spork-backendsvc
nomad job stop -purge -region us-west-2 spork-backendsvc
