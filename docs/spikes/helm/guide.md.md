# Helm/Helm charts
This document outlines a high-level overview of Helm charts and how Helm charts will be used to deploy our services to Kubernetes. This document assumes you would have basic understanding of how manifest files work when deploying a resource to a Kubernetes cluster. As part of this documentation, there has also been an example Helm chart repo created here {URL}.

## What is Helm?
Helm is a Kubernetes deployment tool for automating creation, packaging, configuration, and deployment of applications and services to Kubernetes clusters. Essentially, imagine Helm as a package manager for the Kubernetes system much like choco is for windows, and the packages we install are the apps and services we want to deploy onto the Kubernetes cluster.

## Why Helm?
Imagine we want to deploy a container image to the Kubernetes cluster that will have three replica pods and a service load balancer, we would typically need to create a series of manifest files which will describe these resources then run the 'kubectl apply' command against the respective files to deploy the resources to Kubernetes. It becomes tricky to manage these files manually, having many different manifest files unstructured in a repo and a lot of replicated code within these manifest files with little control over them. Helm essentially provides us with an easy and efficient way to package these files, version them, view history and hence be able to roll-back or upgrade our Kubernetes cluster in accordance with the files and the configuration they specify. Just like Docker gives us the flexibility to choose which version of an image of an app/service we want to run, Helm provides that same flexibility when it comes to running a particular version of a chart, of a specific configuration.

## What is a Helm chart?
A Helm chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on. Below describes the file structure of the chart and its contents.

#This is the repo that contains your chart
-Chart-name/
    #This is the file which contains all the ignores files when packaging the #chart, like gitignore.    
    -.helmignore
    #This file contains meta data/information about the chart that is being #packaged e.g. version no., name of chart etc.
    -Chart.yaml
    #This file contains all the values you want to inject into your templates. #Think of this as Helm's #version of Terraform's variables.tf file. This is #where the magic happens when it comes to versioning, every time you make a #change to the chart or app you upgrade the version number variables in here
    #which will create the basis for rolling/upgrading the Kubernetes cluster.
    -values.yaml
    #This repo contains other library charts that your chart depends on.
    -charts/
    #This folder contains the actual manifest files (yaml) that you are deploying #with the chart. For example you might be deploying an nginx deployment that #needs a service, configmap and secrets. You will have your deployment.yaml, #service.yaml, config.yaml and secrets.yaml all in the template repo. They #will all get their values from values.yaml from above.
    -templates/
    #This repo contains the custom resource definitions.
    -crds/              
    
## Helm commands
Helm commands provides us with a set of powerful and useful commands that helps to create, manage, install, deploy, roll back, etc our charts. Firstly, the helm CLI needs to installed on the machine, below is a list of useful and basic helm commands.

Install an app:
helm install [app-name] [chart]

Upgrade an app:
helm upgrade [release] [chart]

Roll back a release:
helm rollback [release] [revision]

Create a chart (repo):
helm create [name]

Package a chart into a chart archive:
helm package [chart-path]

## Proposed solution/integration with Helm/Helm charts
The proposed solution is to create a Helm chart for each of the component repos, which are the mock classifier, mock bot, DMR and centops within the infrastructure repo as follows:

-helm-charts
    -mock-classifier/ 
        -.helmignore
        -Chart.yaml
        -values.yaml
        -templates/
        -charts/
    -mock-bot/ 
        -.helmignore
        -Chart.yaml
        -values.yaml
        -templates/
        -charts/
    -centops/ 
        -.helmignore
        -Chart.yaml
        -values.yaml
        -templates/
        -charts/
    -dmr/ 
        -.helmignore
        -Chart.yaml
        -values.yaml
        -templates/
        -charts/
        
This proposed repo structure as opposed to having each chart within their own respective repo would firstly provide a 'separation  of concerns' when it comes to isolating the infrastructure components and structures from the actual code of the components. In addition, as an open-source project it will provide efficient management when it comes to a devops perspective in terms of having a 'one stop shop' when it comes to the infrastructure code. When it comes to deployment, the proposed plan which will be fully discussed in a separate CI/CD documentation will essentially at the CI stage build and package the Helm charts using the 'helm package' command, which will create build artifacts and store it for further use. Once the CI stage has completed, then the CD process will be triggered in which, the Helm chart build artifacts will be downloaded and used to upgrade the respective app/resource on the Kubernetes cluster.