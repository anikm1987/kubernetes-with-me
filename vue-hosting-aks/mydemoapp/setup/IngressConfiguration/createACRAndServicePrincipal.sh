#!/bin/bash

# Script to setup ingress using helm in namespace
###############################################################
# Author        : mukherjee.aniket@gmail.com
# Creation Date : 22.05.2020
# Dependency    : Azure environment is available. 
#                 Modify for your environment.
#                 ACR_NAME: The name of your Azure Container Registry
#                 SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
#                 SUBSCRIPTION_NAME: Subscription name
#                 RESOURCE_GROUP : Resource group name
#
# Description   : Script to create ACR and associated service principal with pull role. 
# Execute like  : ./createACRAndServicePrincipal.sh acr_name service_principal_name subscription_name resource_group
###############################################################



ACR_NAME=${1:-mydemoappacr}
SERVICE_PRINCIPAL_NAME=${2:-mydemoapp_sp}
SUBSCRIPTION_NAME=${3:-mydemoapp}
RESOURCE_GROUP=${4:-mydemoapp_rg}

# If you are using service prinicipal for creating ACR then uncomment below 2 lines and update client id and tenant id

# echo "Please enter the password for client-id :"
# az login --service-principal --username <client_id> --password   --tenant <tenant_id>
az account set -s ${SUBSCRIPTION_NAME}
# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

if [ -z ${ACR_REGISTRY_ID} ];then
  az acr create --resource-group ${RESOURCE_GROUP} --name ${ACR_NAME} --sku Basic
  az acr login --name ${ACR_NAME}
  az acr list --resource-group ${RESOURCE_GROUP} --query "[].{acrLoginServer:loginServer}" 
  ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
else
  echo "${ACR_REGISTRY_ID} already exist"
fi
echo "${ACR_REGISTRY_ID}"
# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query password --output tsv)
SP_APP_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"