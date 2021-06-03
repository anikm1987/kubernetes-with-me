Initial Setup - Ingress configuration
---------------------

Getting Started 
-------------

1. Please install helm if already not exist - 
   ```
   # if you have brew support or follow https://helm.sh/docs/intro/install/
   
   brew install helm
   export PATH=/home/ubuntu/.linuxbrew/bin:$PATH
   ```

2. Please fill up the below table as per your enviornment. Update the below tables as per your environment information.

| Name                                     |                Value                    |
| ---------------------------------------- | --------------------------------------- |
| AZURE_TENANT_ID                          |  Update your details                    |
| AZURE_SUBSCRIPTION_NAME                  |  Update your details                    |
| AZURE_RESOURCE_GROUP_NAME                |  Update your details                    |
| AKS_CLUSTER_NAME                         |  Update your details                    |
| AKS_NAMESPACE                            |  'default' or any other namespace name  |
| AZURE_CONTAINER_REGISTRY                 |  Update your details or TO BE CREATED   |
| ACR_SERVICE_PRINCIPAL(Pull and push role)|  Update your details or TO BE CREATED   |
| APPLICATION_DNS_NAME                     |  Update your details                    | 




3. Create AZURE_CONTAINER_REGISTRY & ACR_SERVICE_PRINCIPAL if you do not have existing one -

    ```
    # Navigate to setup\IngressConfiguration and execute below command
    # You need to have service principal creation permission to create service principal with pull access in ACR.

    chmod +x createACRAndServicePrincipal.sh
    ./createACRAndServicePrincipal.sh acr_name service_principal_name subscription_name resource_group

    # Take note of the output as we will use it in later steps. 

    ```

4. If you would like to configure custom DNS then you have replace below files with your details -

    ```
    # Assumption - This require the ingress load balancer ip against which you are going to map the custom DNS.
    # For first time install or if you do not have this IP then continue to next step, get the load balancer ip and rerun this step.

    # If you already have the load balancer ip then update the setup\IngressConfiguration\internal-ingress.yaml file
    # uncomment the line and update the <LOAD_BALANCER_IP>  


    # Name it as per your dns name, this will be used to configure tls in later step
    mydemo.app.com.crt    # APPLICATION_DNS_NAME in above table
    mydemo.app.com.key
    ```
5. Install / configure nginx ingress 

    ```
    # Navigate to setup\IngressConfiguration and execute below command
    chmod +x deployIngresWithHelm.sh
    ./deployIngresWithHelm.sh namespace_name dns_name
    # Follow the user prompts, finally note down the external ip of the load balancer
    ```

6. Verification of ingress

    ```
    kubectl run -it --rm aks-ingress-test --image=debian --namespace ${namespace_name}
    apt-get update && apt-get install -y curl

    curl -L http://10.31.10.101    # Replace the Ip address you receive after deploying ingress
    ```


7. Quick test of ACR and AKS integration (Not mandatory)

    ```
    # If you have already some container image exposing service then you can deploy manually using command line 
    # Assumption: manifests folder contains any sample manifest files for your application and service

    kubectl apply -f manifests/ --namespace ${namespace_name}
    curl -L http://10.31.10.101  # Replace the Ip address you receive after deploying ingress
    ```


