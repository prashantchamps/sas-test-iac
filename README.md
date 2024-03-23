# Test Exercise IaaC for Azure cloud

![sas-test1](https://github.com/prashantchamps/sas-test-iac/assets/42674656/ad6ae4d0-e0e2-4d68-b3d9-94f8529e50aa)

## Introduction
This is a testing exercise which evaluates Kubernetes Engineer. According to this exercise we are going to create a demo application and then host on Azure cloud AKS in automated way called CI/CD using Terraform, GitHub and Flux. 

## Pre-Requisites
1) You need an Azure Subscription with Owner access. 
2) Should have knowledge on Azure (AKS, ACR, VNet, Storage), Terraform, GitHub, GitHub Actions (CI/CD), Flux.

## Steps to create infrastructure on Azure cloud
1) Create a service principal on Azure with Contributor role using CLI.

   `az ad sp create-for-rbac --name sas-test-sp --role Contributor --scopes /subscriptions/<your subscription id> --json-auth`

   It will give you following json structure

   `{
     "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "clientSecret": "your secret",
     "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
     "resourceManagerEndpointUrl": "https://management.azure.com/",
     "activeDirectoryGraphResourceId": "https://graph.windows.net/",
     "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
     "galleryEndpointUrl": "https://gallery.azure.com/",
     "managementEndpointUrl": "https://management.core.windows.net/"
   }`
2) Clone this repository into your github account with name "sas-test-iac"
