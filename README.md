# AWS k8s vpn starter kit

## Overview

Getting started with k8s in AWS has never been easier thanks to EKS.

The AWS k8s vpn starter kit, from CloudFlinger, helps you easily gain network connectivity directly to your pods.

This repository contains

-   Terraform to create a VPC
-   Terraform to create a k8s cluster
-   k8s spec files to install an OpenVPN operator with LDAP support
-   k8s spec files to configure OpenVPN in your k8s cluster

## Pre-requisites

You must [install Docker](https://docs.docker.com/install/) to use the AWS k8s vpn starter kit.

## Setup your LDAP provider

If you do not already have LDAP, we recommend you get started with Foxpass.

Once you have your account, follow these docs to [Set Up a VPN](https://foxpass.readme.io/docs/set-up-a-vpn)

## AWS environment

An aws key pair with IAM permissions to create a VPC and EKS cluster is required to proceed. It must be made available inside the docker container.

### Option 1 - set the env vars in your shell

Set the [AWS cli env vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html) to get started:

-   AWS_ACCESS_KEY_ID
-   AWS_SECRET_ACCESS_KEY
-   AWS_DEFAULT_REGION

### Option 2 - use an aws profile

`AWS_PROFILE` is not supported, however, you can still use your profiles stored in your `~/.aws` folder by running the helper script.

-   You must set `region` in your profile
-   Run the script using the `source` command
    -   ``` source aws_exporter.sh MY_PROFILE_NAME ```

### Option 3 - use docker_env.list

You can add the AWS env vars and their values to `docker_env.list` if you prefer.  We do not recommend this, because you will end up committing these secrets to your repository, and it is not likely what you want.

### Docs on IAM users and access keys

If none of this is making sense, try reading these docs:

-   [Creating your first IAM Admin User and Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
-   [Managing Access Keys for IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Configuration

Modify values in `scripts/env.sh`

```
#!/bin/bash
export CLUSTER_NAME=test-eks-cluster
export ENVIRONMENT_NAME=prod
export VPC_CIDR=10.1.0.0/16
export VPC_NAME=my-vpc
export AWS_REGION=us-west-2
```

## Build the docker

``` make docker-build-kit ```

## Plan the infrastructure

``` make terraform-plan ```
