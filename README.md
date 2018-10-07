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

Note the  `docker_env.list` file.

Environment variables set here are available in the docker.

## AWS environment

An aws key pair with IAM permissions to create a VPC and EKS cluster is required to proceed.

Once you have this keypair you must set these env vars:

-   AWS_ACCESS_KEY_ID
-   AWS_SECRET_ACCESS_KEY
-   AWS_DEFAULT_REGION

If your credentials are stored in your `~/.aws` folder, you can use the provided helper script to set the env vars.  You must set `region` in your credentials file so it gets set properly.

``` source aws_exporter.sh MY_PROFILE_NAME ```

`AWS_PROFILE` is not supported.

If you still aren't sure what to do here, follow these docs:

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

From within the `/terraform` folder, `init` and then `apply`.

```
terraform init
terraform apply
```

## OpenVPN install (inside docker)

From within the `/k8s-specs` folder:

```
kubectl -f 00_storage_class.yaml
for SPEC in $(ls -1 01_olm*);do kubectl -f $SPEC;done
kubectl -f 02_vpn_operator.yaml
kubectl -f 03_vpn_cr.yaml
```
