# AWS k8s vpn starter kit

Following this guide will lead to having a private network in AWS with a kubernetes cluster running an openvpn server that is available via the internet. 

## Overview

Many organizations have the same concerns when it comes to delivering value. They need some user facing software that stores data in a protected database server and they need some way to access the databases securely. As things grow they may develop more complicated software and evolve their processes around releasing that software.

Having seen this process unfold at many companies, we've codified the process so that you can get up and going quickly with a set of tools that we find work well together to set a foundation for your organization's operations workflows.

From experience we also know how much time can be wasted setting up workstations and how, often times, the script to get started breaks down due to dependencies changing and projects evolving.

The AWS k8s vpn starter kit helps you easily create a private network, spawn a kubernetes cluster, and gain secure network connectivity directly to your applications.

This repository uses popular tools including [Docker](https://www.docker.com/), [Terraform](https://www.terraform.io/), [Kubernetes](https://kubernetes.io/), [Amazon Web Services](https://aws.amazon.com/), and [OpenVPN](https://openvpn.net/). As much as possible we are relying on code written and maintained by different communities and really just gluing them together.

At a high level this repository is composed of 

- A dockerfile to create an image to run all of our tooling in
- A makefile to expose useful commands for creating and interacting with infrastructure.
- Terraform to create networking, compute, and IAM resources (VPC + EKS + IAM)
- Kubernetes spec files to install OpenVPN backed by LDAP. (Bring your own LDAP)
- A little glue code that powers the makefile.

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

### Option 2 - use an AWS profile

`AWS_PROFILE` is supported, with one condition:

-   You must set `region` in your profile

Example

```
AWS_PROFILE=cloudflinger make terraform-plan
```

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
