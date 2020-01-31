# Deploy you cluster with a standalone IM

## Requirements

- Docker
- access to a cloud provider
- curl

## Run a local instance of the Infrastructure Manager

We are going to spin up an instance of IM with docker:

```bash
sudo docker run -d -p 8899:8899 -p 8800:8800 -v "/<some_local_path for db>:/db" -e IM_DATA_DB=/db/inf.dat --name im grycap/im:1.9.0
```

other installing options are available [here](https://imdocs.readthedocs.io/en/latest/manual.html#docker-image)

> **N.B** be careful of not loosing the folder where IM stores deployment information (the one mounted in the container). Otherwise you will need to remove the created resources by hand from the cloud provider ui.

## Setting up dodas client

Create a config file in `$HOME/.dodas.yaml`:

```yaml
cloud:
  id: ost
  type: OpenStack
  host: <your cloud host> # e.g. https://horizon.cloud.cnaf.infn.it:5000/
  username: <user>
  password: <pwd>
  tenant: <your tenant>
  auth_version: <you auth version> # e.g. 3.x_oidc_access_token
  #service_region: regionOne
  #domain:
im:
  id: im
  type: InfrastructureManager
  host: http://localhost:8800/infrastructures
  username: test
  password: test
```

and fill up the fields needed for you cloud provider.

Download the binary from the latest release on [github](https://github.com/DODAS-TS/dodas-go-client/releases). For instance:

```bash
wget https://github.com/DODAS-TS/dodas-go-client/releases/download/v0.3.3/dodas.zip
unzip dodas.zip
cp dodas /usr/local/bin
```

In alternative you can also run the dodas command inside the client container `dodasts/dodas-client:v0.3.3`.

## Install your application

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
    Submitting request to  :  http://localhost:8800/infrastructures
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
