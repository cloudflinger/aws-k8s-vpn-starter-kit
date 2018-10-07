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

## Setup your AWS environment

You need an aws key pair with IAM permissions to create a VPC and EKS cluster.

Before you can run Terraform, configure environment variables:

```
#!/bin/bash
export AWS_ACCESS_KEY_ID="AKIAJ......."
export AWS_SECRET_ACCESS_KEY="po7sOhAn..............."
export AWS_DEFAULT_REGION="us-west-2"
```

## Create the infrastructure

```
aws-k8s-vpn-starter-kit/terraform$ terraform init
aws-k8s-vpn-starter-kit/terraform$ terraform apply
```
