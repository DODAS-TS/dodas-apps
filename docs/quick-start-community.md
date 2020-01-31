# Deploy you cluster with the enabling facility

## Requirements

- IAM credentials for accessing the Enabling Facility resources
  - Register to the IAM-DODAS service by accessing the service [here](https://dodas-iam.cloud.cnaf.infn.it). You can use your IdP because IAM-DODAS supports eduGAIN identity federation. The first registration will require the approval from the DODAS admins.
- access to a cloud provider
- curl

## Get your access token

Just execute this [script](https://github.com/DODAS-TS/dodas-templates/tree/master/utils/get_token.sh) and put inside the `client_id` and `client_secret` provided by the procedure described [here](https://indigo-iam.github.io/docs/v/current/user-guide/client-registration.html)

> If you find any issue please do not hesitate to contact us

Now you are ready to deploy your application.

## Setting up dodas client

Create a config file in `$HOME/.dodas.yaml`:

```yaml
cloud:
  ## CNAF resources
  id: ost
  type: OpenStack
  host: https://horizon.cloud.cnaf.infn.it:5000/
  username: indigo-dc
  password: <your token here>
  tenant: oidc
  auth_version: 3.x_oidc_access_token
  service_region: regionOne
  ## RECAS resources
  #id: ost
  #type: OpenStack
  #host: https://cloud.recas.ba.infn.it:5000/
  #username: indigo-dc
  #password: <your token here>
  #tenant: oidc
  #auth_version: 3.x_oidc_access_token
  #service_region: recas-cloud
im:
  id: im
  type: InfrastructureManager
  host: https://im-dodas.cloud.cnaf.infn.it/infrastructures
  token: <your token here>
```

and fill up the fields needed for you cloud provider.

Download the binary from the latest release on [github](https://github.com/DODAS-TS/dodas-go-client/releases). For instance:

```bash
wget https://github.com/DODAS-TS/dodas-go-client/releases/download/v0.3.3/dodas.zip
unzip dodas.zip
cp dodas /usr/local/bin
```

In alternative you can also run the dodas command inside the client container `dodasts/dodas-client:v0.3.3`.

## Quick start

Let's take Apache Spark deployment on K8s as an example. The template to be used is [this](https://github.com/DODAS-TS/dodas-templates/tree/master//templates/applications/k8s/template-spark.yml).
To start your deployment:

```bash
dodas create dodas-templates/templates/applications/k8s/template-spark.yaml
```

The output should be like this:

```bash
    validate called
    Template OK
    Template: dodas-templates/templates/applications/k8s/template-spark.yml
    Submitting request to  :  https://im-dodas.cloud.cnaf.infn.it/infrastructures
    InfrastructureID:  9b917c8c-4345-11ea-b524-0242ac150003
```

To get the infrastructure ID (infID) of all your deployments

```bash
dodas list infIDs
```

And the output should be like this:

```text
    infIDs called
    Submitting request to  :  https://im-dodas.cloud.cnaf.infn.it/infrastructures
    Infrastructure IDs:
    9b917c8c-4345-11ea-b524-0242ac150003
    def0708e-4343-11ea-8e50-0242ac150003
```

To check the status of the deployment

```bash
dodas get status <infID>
```

And to get the output of the deployment

```bash
dodas get output <infID>
```

And the output should be like this:

```bash
status called
Submitting request to  :  https://im-dodas.cloud.cnaf.infn.it/infrastructures
Deployment output:
{"outputs": {"k8s_endpoint": "https://90.147.75.134:30443"}}
```

Then, to access the k8s dashboard go to https://90.147.75.134:30443 and to access the jupyter notebook go to https://90.147.75.134:30888.

To log into one of the VM created by the deployment:

```bash
dodas login <infID> <vmID>
sudo su
```
