# IaaC Test Exercise for Azure cloud

## Architecture Diagram

![sas-test1](https://github.com/prashantchamps/sas-test-iac/assets/42674656/ad6ae4d0-e0e2-4d68-b3d9-94f8529e50aa)

## Introduction
This is a testing exercise which evaluates Kubernetes Engineer. According to this exercise we are going to create a demo application and then host on Azure cloud AKS in automated way called CI/CD using Terraform, GitHub and Flux.

This repository only fulfill the creation of core needed resources for the test exercise. There are other 2 repositories as well which are related to this, Please read their relevent document to complete the exercise. 

[Test Application](https://github.com/prashantchamps/sas-test-application/blob/main/README.md)

[Manifest](https://github.com/prashantchamps/flux-image-updates/blob/main/README.md)

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
3) Change variable named "owner_username" according to your GitHub account.
4) Create a PAT from your GitHub account having all repo access.
5) Create below repository level secrets and give appropriate values from step1 json and step4.
   - ARM_CLIENT_ID
   - ARM_CLIENT_SECRET
   - ARM_SUBSCRIPTION_ID
   - ARM_TENANT_ID
   - AZURE_CREDENTIALS
   - GIT_TOKEN
6) Go to GitHub actions and run workflow Infrastructure Pre-Requisites. This will create a resource group and your storage account for Terraform with in that RG.
7) Now run workflow "Infrastructure". This will create the core needed resources on Azure cloud.
   > [!NOTE]
   > Currently it is kept as manual run but we can automate it's trigger on completion of pevious workflow. 
8) Now run following CLI for attaching ACR with AKS which are created in step5.
   
   `az aks update -n sas-test-aks -g sas-test --attach-acr sasaksacrtest`

   > [!CAUTION]
   > On executing CLI, If you get below error then please wait for 2 to 3 mins more and then run CLI again.
   > 
   > The resource with name 'sasaksacrtest' and type 'Microsoft.ContainerRegistry/registries' could not be found in subscription 'your       > subscription'.
9) Create the secret on k8s for accessing ACR from flux using kubectl command. This secret is already provided in sas-test-app-registry file of manifest repository i.e. [Manifest](https://github.com/prashantchamps/flux-image-updates). Please take client-id and client-secret from step 1.

   `az aks get-credentials --resource-group sas-test --name sas-test-aks`
   `kubectl create secret docker-registry regcred --docker-server=sasaksacrtest.azurecr.io --docker-username=<client-id> --docker-password=<client-secret> -n flux-system`
10) Follow document of [Test Application](https://github.com/prashantchamps/sas-test-application/blob/main/README.md) repository to deploy it.

## Conclusion
