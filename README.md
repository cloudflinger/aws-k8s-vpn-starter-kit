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

Once you have your account, follow these docs to [Set Up a VPN](https://foxpass.readme.io/docs/set-up-a-vpn)

## Docker environment

Note the `docker_env.list.example` file.  Copy it to `docker_env.list`.

Modifications to `docker_env.list` will be picked up by terraform and kubectl.

## AWS environment

An aws key pair with IAM permissions to create a VPC and EKS cluster is required to proceed.

Add these values to `docker_env.list`

If you aren't sure where to get find this, follow these docs:

-   [Creating your first IAM Admin User and Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
-   [Managing Access Keys for IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Build the docker

``` docker_build.sh ```

## Run the docker

``` docker_run.sh ```

## Infrastructure configuration

Modify values in `/terraform/config.tf`

```
...
environment_name = "prod" # used for resource tagging
vpc_cidr         = "10.1.0.0/16"
vpc_name         = "my-vpc"
aws_region       = "us-west-2"
cluster_name     = "test-eks-cluster"
...
```

## Infrastructure provisioning (inside docker)

Next, from within the `/terraform` folder, `init` and then `apply`.

```
terraform init
terraform apply
```
