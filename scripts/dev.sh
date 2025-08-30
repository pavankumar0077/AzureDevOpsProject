#!/bin/bash
set -e

SUBSCRIPTION_ID=17bdce33-d699-4d78-88e5-720d6068a474
RESOURCE_GROUP_NAME=terraform-state-rg
STAGE_SA_ACCOUNT=tfstagebackend2025pan
DEV_SA_ACCOUNT=tfdevbackend2025pan
CONTAINER_NAME=tfstate
LOCATION=canadacentral

# Ensure we are on the correct subscription
az account set --subscription $SUBSCRIPTION_ID

# Create resource group
az group create --subscription $SUBSCRIPTION_ID --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage accounts
az storage account create --subscription $SUBSCRIPTION_ID --resource-group $RESOURCE_GROUP_NAME --name $STAGE_SA_ACCOUNT --sku Standard_LRS --encryption-services blob
az storage account create --subscription $SUBSCRIPTION_ID --resource-group $RESOURCE_GROUP_NAME --name $DEV_SA_ACCOUNT --sku Standard_LRS --encryption-services blob

# Create blob containers (with auth mode login)
az storage container create --subscription $SUBSCRIPTION_ID --name $CONTAINER_NAME --account-name $STAGE_SA_ACCOUNT --auth-mode login
az storage container create --subscription $SUBSCRIPTION_ID --name $CONTAINER_NAME --account-name $DEV_SA_ACCOUNT --auth-mode login

echo "✅ Storage accounts and containers created successfully!"
echo "Stage: $STAGE_SA_ACCOUNT"
echo "Dev:   $DEV_SA_ACCOUNT"
