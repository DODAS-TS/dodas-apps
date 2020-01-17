# DODAS: TOSCA templates for applications

## Requirements
In order to get your application to work, you need valid Indigo IAM credentials.

## Setting up dodas client
````
wget https://github.com/Cloud-PG/dodas-go-client/releases/download/v0.3.3/dodas.zip
unzip dodas.zip
cp dodas /usr/local/bin
````
If you are using MacOS X, you have to download https://github.com/Cloud-PG/dodas-go-client/releases/download/v0.3.3/dodas_osx.zip instead.

In order to deploy your application:
````
dodas create template.yaml
````

To check the status of the deployment
````
dodas get status <infID>
````

And to get the output of the deployment
````
dodas get output <infID>
````

To log into one of the VM created by the deployment:
````
dodas login <infID> <vmID>
sudo su
````

## Available containers orchestrators

### K3s

### Kubernetes

## Available applications
### Spark
[template](templates/applications/k3s/template-spark.yml)
[template](templates/applications/k8s/template-spark.yml)
### HTCondor
[template](templates/applications/k3s/template-htcondor.yml)
[template](templates/applications/k8s/template-htcondor.yml)
### CachingOnDemand
[template](templates/applications/k3s/template-cachingondemand.yml)
[template](templates/applications/k8s/template-cachingondemand.yml)
### OpenFAAS
[template](templates/applications/k3s/template-openfaas.yml)
[template](templates/applications/k8s/template-openfaas.yml)