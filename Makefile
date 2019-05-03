.PHONY: fmt fmt_terraform lint lint_terraform terraform

DOCKER := docker run -itu `id -u`:`id -g`
TERRAFORM := hashicorp/terraform:light
TERRAFORM_DIR := -v ${CURDIR}/terraform:/terraform -w /terraform
SHELL := /bin/bash

fmt: fmt_terraform

fmt_terraform:
	${DOCKER} ${TERRAFORM_DIR} ${TERRAFORM} fmt

lint: lint_terraform

lint_terraform:
	${DOCKER} ${TERRAFORM_DIR} ${TERRAFORM} fmt --check=true --write=false

terraform_init:
	${DOCKER} ${TERRAFORM_DIR} ${TERRAFORM} init

terraform_plan:
	${DOCKER} ${TERRAFORM_DIR} ${TERRAFORM} plan
