#!/bin/bash

# fail on any error
set -eu

# initialize terraform
terraform init

# # apply terraform
# terraform apply -auto-approve

# destroy terraform
terraform destroy -auto-approve