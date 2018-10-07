# AWS k8s vpn starter kit

## Overview

Getting started with k8s in AWS has never been easier thanks to EKS.

The AWS k8s vpn starter kit, from CloudFlinger, helps you easily gain network connectivity directly to your pods.

This repository contains

-   Terraform to create a VPC
-   Terraform to create a k8s cluster
-   k8s spec files to install an OpenVPN operator with LDAP support
-   k8s spec files to configure OpenVPN in your k8s cluster

## Setup your LDAP provider

If you do not already have LDAP, we recommend you get started with Foxpass.

## AWS environment

An aws key pair with IAM permissions to create a VPC and EKS cluster is required to proceed.

If you aren't sure where to get this, read the documentation on [Creating your first IAM Admin User and Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) and [Managing Access Keys for IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Infrastructure configuration

Modify values in `terraform/config.tf`

```
...
environment_name = "prod" # used for resource tagging
vpc_cidr         = "10.1.0.0/16"
vpc_name         = "my-vpc"
aws_region       = "us-west-2"
cluster_name     = "test-eks-cluster"
...
```

## Infrastructure provisioning

Before you can run Terraform, configure environment variables:

```
export AWS_ACCESS_KEY_ID="AKIAJ......."
export AWS_SECRET_ACCESS_KEY="po7sOhAn..............."
export AWS_DEFAULT_REGION="us-west-2"
```

Next, from within the `terraform` folder, `init` and then `apply`.

```
terraform init
terraform apply
```
