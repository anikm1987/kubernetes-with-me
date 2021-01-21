Static Website deployed in AKS
----------------------

Getting Started
--------------

#### Pre-requisites
| Software                         |
| ---------                        |
| Nodejs (14.15.4)                 |
| git ( and access to github)      |
| vue cli and yarn                 |

#### Project setup

1. Clone the repo:
  ```
  $ git clone https://github.com/anikm1987/kubernetes-with-me.git
  $ cd kubernetes-with-me/vue-hosting-aks/mydemoapp
  ```

2. Install the dependencies: Compiles and hot-reloads for development
    ```
    yarn install
    yarn serve
    ```
3. Navigate to [http://localhost:8080](http://localhost:8080)

#### Compiles and minifies for production
```
yarn build
```

#### Lints and fixes files
```
yarn lint
```

#### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).


Testing locally with Dockerfile
--------------------

You need to have docker installed in your local machine. Navigate to the project folder and execute below commands -
```
docker build -t anikm1987/mydemoapp:1.0.0 .
docker run -p 8080:80 anikm1987/mydemoapp:1.0.0
```

#### Commit your code to your github account which you will be using inside Azure devops


Setting up the Azure Devops CI/CD pipeline
-----------------------

#### Pre-requisites
| Details                          |
| ---------                        |
| Azure Devops account to run the pipeline                 |
| Azure cloud access      |
| Azure Resource Group and Service Principal |
| Azure Kubernetes Cluster and a namespace created inside |
| Azure container registry created and accesible from Azure Kubernetes cluster |
| Azure Kubernetes cluster is accessible from Azure devops | 
| Reference - [Azure Kubernetes Tutorial](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app) |



### Service Connection requirement for pipeline

1. Navigate to your Azure devops account and create one new project or you can use an existing project.
   For reference - [Create Project](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page)

2. Navigate to Project settings => Service connections, here we will create 4 service connections -
    - Azure Service Connection to subscription.
    - Github service connection.
    - Azure container rgistry connection.
    - Azure Kubernetes environment connection.

3. TODO
    
