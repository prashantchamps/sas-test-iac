# IaaC Test Exercise for Azure cloud

## Architecture Diagram

![sas-test1](https://github.com/prashantchamps/sas-test-iac/assets/42674656/ad6ae4d0-e0e2-4d68-b3d9-94f8529e50aa)

## Introduction
This is a testing exercise which evaluates Kubernetes Engineer. According to this exercise we are going to create a demo application and then host on Azure cloud AKS in automated way called CI/CD using Terraform, GitHub and Flux.

This repository only fulfill the creation of core needed resources for the test exercise. There are other 2 repositories as well which are related to this, After completing below steps, Please read their relevent document to complete the exercise. 

[Test Application](https://github.com/prashantchamps/sas-test-application/blob/main/README.md)

[Manifest](https://github.com/prashantchamps/flux-image-updates/blob/main/README.md)

## Pre-Requisites
1) You need an Azure Subscription with Owner access. 
2) Should have basic understanding of Azure (AKS, ACR, VNet, Storage), Terraform, GitHub, GitHub Actions (CI/CD), Flux.

## Steps to create infrastructure on Azure cloud
1) Create a **service principal** on Azure with Contributor role using below CLI.

   `az ad sp create-for-rbac --name sas-test-sp --role Contributor --scopes /subscriptions/<your subscription id> --json-auth`

   It will give you following json structure having client-id and secret.

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

   Contributor role assigned to this SP is not sufficient to give access permissions, so either we have to create a custom role to write     role assignment or we can assign azure inbuilt role "Role Based Access Control Administrator" to SP. Here we are going with second way    using below CLI.

   `az role assignment create --assignee "your SP application id" --role "Role Based Access Control Administrator" --scope 
   "/subscriptions/your subscription id"`
   
3) Clone all 3 repository into your github account with the same name (i.e. flux-image-updates, sas-test-iac, sas-test-application).
4) Change variable named **"owner_username"** in variable.tf according to your GitHub account.
5) Create a PAT from your GitHub account having all types of repository access.
6) Create below repository level **secrets** and give appropriate values from step1 json and step4.
   - ARM_CLIENT_ID
   - ARM_CLIENT_SECRET
   - ARM_SUBSCRIPTION_ID
   - ARM_TENANT_ID
   - AZURE_CREDENTIALS
   - GIT_TOKEN
7) Now we are ready to run workflows, so go to GitHub actions and run workflow **"Infrastructure Pre-Requisites"**. This will create a 
   resource group and your storage account for Terraform.
8) Now run workflow **"Infrastructure"**. This will create the core needed resources on Azure cloud.
   > [!NOTE]
   > Currently it is kept as manual run but we can automate it's trigger on completion of pevious workflow.
9) Create the secret on k8s for accessing ACR from flux using kubectl command. This secret is already provided in sas-test-app-registry.yaml file of manifest repository i.e. [Manifest](https://github.com/prashantchamps/flux-image-updates). Please take client-id and client-secret from step 1 to execute below CLI.

   `az aks get-credentials --resource-group sas-test --name sas-test-aks`
   `kubectl create secret docker-registry regcred --docker-server=sasaksacrtest.azurecr.io --docker-username=<client-id> --docker-            password=<client-secret> -n flux-system`
10) Follow document of [Test Application](https://github.com/prashantchamps/sas-test-application/blob/main/README.md) repository to           deploy it. Also please refer document of [Manifest](https://github.com/prashantchamps/flux-image-updates/blob/main/README.md)             repository to see the differnt yamls that are created for CD (Continuous Deployment).

## How to Test
After following above steps you can check on Azure portal. Below resources should get created.
1) AKS: sas-test-aks
2) ACR: sasaksacrtest
3) VNET: sas-test-vnet
4) STORAGE: sastesttfstate

Now go to sas-test-aks and check "aks-helloworld" in workloads should be up and running then check services and ingress.
After deployment 2 Public facing IP will get generated, one will be load balancer and other will be Ingress Nginx. Check on azure portal and browse that ip address, the react js application should load its welcome page.

**I have used Flux "Automate image updates to Git" for CD**
So for testing CI with GitHub Actions and CD with Flux, edit workflow "Build-Push-Image.yml" in repository "sas-test-application" and increment the tag of image. Now run the workflow and wait for its completion. After completion the image tag should get updated into AKS "aks-helloworld" workload **automatically**.

## Conclusion
After following all the steps our environment will be ready. DevOps team will be able to push any environment related changes using teraform and manifest repository simultaneously Developer team will be able to deploy their new application code changes using CICD.

