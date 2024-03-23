# IaaC Test Exercise for Azure cloud

## Architecture Diagram

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
2) Clone this repository into your github account with name "sas-test-iac".
3) Create a PAT from your GitHub account having all repo access.
4) Create below repository level secrets and give appropriate values from step1 json and step3.
   - ARM_CLIENT_ID
   - ARM_CLIENT_SECRET
   - ARM_SUBSCRIPTION_ID
   - ARM_TENANT_ID
   - AZURE_CREDENTIALS
   - GIT_TOKEN
5) Go to GitHub actions and run workflow Infrastructure Pre-Requisites. This will create a resource group and your storage account for Terraform with in that RG.
6) Now run workflow Infrastructure. This will create the core needed resources on Azure cloud.
   > [!NOTE]
   > Currently it is kept as manual run but we can automate it's trigger on completion of pevious workflow. 
8) Now run following CLI for attaching ACR with AKS which are created in step5.
   
   `az aks update -n sas-test-aks -g sas-test --attach-acr sasaksacrtest`

   > [!CAUTION]
   > On executing CLI, If you get below error then please wait for 2 to 3 mins more and then run CLI again.
   > 
   > The resource with name 'sasaksacrtest' and type 'Microsoft.ContainerRegistry/registries' could not be found in subscription 'your       > subscription'.
9) Your infrastructure is ready now.

## Conclusion
