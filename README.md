# DODAS: TOSCA templates for applications

## Requirements
In order to get your application to work, you need valid Indigo IAM credentials and an available OpenStack cloud infrastructure.

## Setting up dodas client
````
wget https://github.com/Cloud-PG/dodas-go-client/releases/download/v0.3.3/dodas.zip
unzip dodas.zip
cp dodas /usr/local/bin
````

If you are using MacOS X, you have to download https://github.com/Cloud-PG/dodas-go-client/releases/download/v0.3.3/dodas_osx.zip instead.


Create a .dodas-template.yaml:
`````
vim .dodas-template.yaml
``````

and put this inside

`````
cloud:
    id: ost
    type: OpenStack
    host: https://cloud.recas.ba.infn.it:5000/
    username: indigo-dc
    password: token_template
    tenant: oidc
    auth_version: 3.x_oidc_access_token
    service_region: recas-cloud
im:
    id: im
    type: InfrastructureManager
    host: https://im-dodas.cloud.cnaf.infn.it/infrastructures
    token: token_template

`````

Then, create a get_orchet_token.sh 
````
vim get_orchet_token.sh 
````

and write inside:

````
#!/usr/bin/env bash

IAM_CLIENT_ID=dodas-demo
IAM_CLIENT_SECRET=dodas-demo

IAM_CLIENT_ID=${IAM_CLIENT_ID:-iam-client}
IAM_CLIENT_SECRET=${IAM_CLIENT_SECRET}

echo -ne "IAM User:"
read IAM_USER

echo -ne "Password:"
stty -echo
read IAM_PASSWORD
stty echo

echo

res=$(curl -s -L \
  -d client_id=${IAM_CLIENT_ID} \
  -d client_secret=${IAM_CLIENT_SECRET} \
  -d grant_type=password \
  -d username=${IAM_USER} \
  -d password=${IAM_PASSWORD} \
  -d scope="openid profile email offline_access" \
  ${IAM_ENDPOINT:-https://dodas-iam.cloud.cnaf.infn.it/token}
)

if [ $? != 0 ]; then
  echo "Error!"
  exit 1
fi

access_token=$(echo $res | jq -r .access_token)

echo $access_token
sed -e "s/token_template/${access_token}/" $HOME/.dodas-template.yaml > $HOME/.dodas.yaml
````

Once you have done this, run

`````
sh get_orchent_token.sh
``````

and put your Indigo IAM credentials in order to get your token which will be automatically put inside your newly created .dodas.yaml file. 

Now you are ready to deploy your application, running:

````
dodas create template.yaml
````

where ```template.yaml``` is a TOSCA template.

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
With these templates you can deploy Apache Spark on top of either k3s or k8s:
- [Spark on k3s](templates/applications/k3s/template-spark.yml)
- [Spark on k8s](templates/applications/k8s/template-spark.yml)
### HTCondor
With these templates you can deploy HTCondor on top of either k3s or k8s:
- [HTCondor on k3s](templates/applications/k3s/template-htcondor.yml)
- [HTCondor on k8s](templates/applications/k8s/template-htcondor.yml)
### CachingOnDemand
With these templates you can deploy Caching On Demand on top of either k3s or k8s:
- [CachingOnDemand on k3s](templates/applications/k3s/template-cachingondemand.yml)
- [CachingOn Demand on k8s](templates/applications/k8s/template-cachingondemand.yml)
### OpenFAAS
With these templates you can deploy OpenFaas on top of either k3s or k8s:
- [OpenFaas on k3s](templates/applications/k3s/template-openfaas.yml)
- [OpenFaas on k8s](templates/applications/k8s/template-openfaas.yml)

All of these templates uses the helm charts defined in https://github.com/DODAS-TS/helm_charts/tree/master/stable.