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

## Requirements

### Docker

Docker must [be installed](https://docs.docker.com/install/) on your workstation.

We rely on docker to build/download our toolkit for creating and managing our cloud resources and application deployments.

By using docker in this way, we save you a bunch of time in setup for your workstation and can verify certain versions of the tooling as known to work well together.

### LDAP

We are assuming LDAP as the backing authentication mechanism for the VPN. You'll have to provide your own LDAP implementation for now. The configuration will be convered later but you'll need the ldap url, a username & password to connect to the ldap server as the vpn server, and a filter to specify which ldap users can log in to the VPN.

If you do not already have LDAP, we recommend you get started with [Foxpass](https://www.foxpass.com/).

Once you have your account, follow these docs to [Set Up a VPN](https://foxpass.readme.io/docs/set-up-a-vpn)

### AWS Account & Credentials

For use with this starter kit you'll need an [AWS Account](https://aws.amazon.com/). This starter kit is not designed to be used with the free tier and will incur non-trivial cost.

An aws key pair with IAM permissions to create a VPC and EKS cluster is required to proceed. We use the credentials to authorize terraform to create resources in your amazon account.

This kit attempts to integrate with common aws cli based workflows. 

Not yet, but the targeted implementation is to first check if `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` are set. If they are, then we use those values. If they aren't then we check to see if `$AWS_PROFILE` is set. If it isn't then we set it to "default". We then look up and set `$AWS_ACCESS_KEY_ID`, and `$AWS_SECRET_ACCESS_KEY` from the aws configuration directory, which defaults to `~/.aws/`. If we are unable to find a satisfactory value for `$AWS_ACCESS_KEY_ID` or `$AWS_SECRET_ACCESS_KEY` then we will not proceed.

We then look up the region configured in `$AWS_DEFAULT_REGION`. If it is not set we set it from the aws configuration directory. If we are unable to find a value for `$AWS_DEFAULT_REGION` we will not proceed.

Set the [AWS cli env vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html) to get started

**Required Environment Variables:**
-   AWS_ACCESS_KEY_ID
-   AWS_SECRET_ACCESS_KEY
-   AWS_DEFAULT_REGION

**or*

- `AWS_PROFILE`
- a properly configured aws installation including region

Example

```
AWS_PROFILE=cloudflinger make terraform-plan
```

#### Docs on IAM users and access keys

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
