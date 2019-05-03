#!/bin/bash
set -o xtrace
nomad job stop -purge -region us-west-2 spork-backendsvc
