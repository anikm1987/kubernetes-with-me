#!/bin/bash
# Script to setup ingress using helm in namespace
###############################################################
# Author        : mukherjee.aniket@gmail.com
# Creation Date : 22.05.2020
# Dependency    : kubectl is depployed, user logged into the cluster
#                 helm is installed
#
# Description   : Script to setup ingress using helm in namespace
# Execute like  : ./deployIngresWithHelm.sh namespace_name dns_name
###############################################################
# NOTE :

namespace_name=${1:-mydemoapp-namespace}
dns_name=${2:-mydemo.app.com}

#Function to check if Azure CLI and Kubectl are installed
programexists()
{
  command -v "$1" >/dev/null 2>&1
}


echo "checking prerequisites"
if programexists kubectl; then
  echo 'kubectl exists'
else
  echo 'Your system does not have kubectl installed. Please install to continue'
  exit 1
fi
if programexists helm; then
  echo 'helm exists'
else
  echo 'Your system does not have helm installed. Please install Helm 3 to continue'
  exit 1
fi

# Checking connectivity with AKS cluster
kubectl get pods --namespace ${namespace_name}
exitStatus=$?
  if [ $exitStatus -eq 0 ];then
    echo "Login to namespace is complete"
  else
    echo "ERROR: Unable to access the cluster. Please login using kubectl into the cluster and try again"
    echo "Execute below commands for production"
    echo "az login" 
    echo "az account set --subscription <subscription_name>"
    echo "az aks get-credentials --resource-group <resorce_group_name> --name <aks_cluster_name> --overwrite-existing"
    exit 1
  fi

if [ ! -f "internal-ingress.yaml" ]; then
      echo "FATAL: internal-ingress.yaml not present, please add the file"
      exit 3
else
echo "NOTE: If you already have the load balancer ip for ingres then uncomment the section inside internal-ingress.yaml"
echo " and update the <LOAD_BALANCER_IP>. Launch again the script. If you do not have load balancer ip then continue .."
echo "This is required to avoid generation of new ip addresses for each deployment of ingress"
fi

echo -n "Do you wish to continue? [y/N]: "
read answ
if [ "${answ^^*}" != "Y" ]; then
    echo "You have chosen to stop the execution, exiting...."
    exit 1
else
  helm repo add stable https://charts.helm.sh/stable
  helm repo update
  helm install nginx-ingress stable/nginx-ingress --namespace ${namespace_name} -f internal-ingress.yaml --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --set controller.service.externalTrafficPolicy=Local --set controller.scope.enabled=true --set controller.update-status=false --set rbac.scope=true --set controller.watchNamespace=${namespace_name}
  kubectl get service -l app=nginx-ingress --namespace ${namespace_name}
  echo "Execute - kubectl get service -l app=nginx-ingress --namespace ${namespace_name} if you dont see the EXTERNAL-IP yet"
fi

# Below section may require some update if you have separate name for you DNS server certificate and credential key
if [ -f "${dns_name}.crt" ]; then
  echo -n "Do you wish to configure tls? [y/N]: "
  read answ
  if [ "${answ^^*}" != "Y" ]; then
    echo "You have chosen to stop the execution, exiting...."
    exit 1
  else
    echo "Setting up tls .."
    kubectl create secret tls aks-ingress-tls --namespace ${namespace_name} --key ${dns_name}.key --cert ${dns_name}.crt
  fi
fi