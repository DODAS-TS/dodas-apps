# Deploy HTCondor cluster with an enabling facility

Before starting be sure to have all the [requirements](./README.md#requirements) satisfied.

## Get your access token

This step should be as simple as:

```bash
oidc-token dodas
```

## Setting up dodas client

Create a config file in `$HOME/.dodas.yaml`:

```yaml
cloud:
  id: ost
  type: OpenStack
  host: https://horizon.cloud.cnaf.infn.it:5000/
  username: indigo-dc
  password: <your token here>
  tenant: oidc
  auth_version: 3.x_oidc_access_token
  service_region: regionOne
im:
  id: im
  type: InfrastructureManager
  host: https://im-dodas.cloud.cnaf.infn.it/infrastructures
  token: <your token here>
```

and fill up the fields needed for you cloud provider.

Download the binary from the latest release on [github](https://github.com/DODAS-TS/dodas-go-client/releases). For instance:

```bash
wget https://github.com/DODAS-TS/dodas-go-client/releases/download/v1.3.0/dodas.zip
unzip dodas.zip
cp dodas /usr/local/bin
```

## Quick start

### Configure your cluster

Let's take a look at how to deploy HTCondor on your OpenStack resources. The template to be used is [this](https://github.com/DODAS-TS/dodas-templates/tree/master//templates/applications/k8s/template-htcondor.yml).
The TOSCA file is divided in section. The only one that is of our interest for now is the input one that start with generic information on the flavor and image of the VMs to be created:

```yaml
    number_of_masters:
      type: integer
      default: 1

    num_cpus_master: 
      type: integer
      default: 2

    mem_size_master:
      type: string
      default: "4 GB"

    number_of_slaves:
      type: integer
      default: 1 

    num_cpus_slave: 
      type: integer
      default: 4

    mem_size_slave:
      type: string
      default: "8 GB"

    server_image:
      type: string
      #default: "ost://openstack.fisica.unipg.it/cb87a2ac-5469-4bd5-9cce-9682c798b4e4"
      default: "ost://horizon.cloud.cnaf.infn.it/3d993ab8-5d7b-4362-8fd6-af1391edca39"
      # default: "ost://cloud.recas.ba.infn.it/1113d7e8-fc5d-43b9-8d26-61906d89d479"
```

Fill every field as you like. And proceed on the next block that you can ignore if you don't want to mount an NFS endpoint on each worker node

```yaml
    nfs_path:
      type: string
      default: "NOT NEEDED"

    nfs_master_ip:
      type: string
      default: "NOT NEEDED"
```

Then you should include on the following block a valid IAM token obtained with `oidc-token dodas`:

``` yaml
    htcondor_docker_image:
      type: string
      default: "dodasts/htcondor"

    iam_token:
      type: string
      default: "CHANGEME"
```

The final block is the core of the deployment as it represent the value file of the HELM deployment (for more info on HELM you can navigate their [documentation](https://helm.sh/docs/), while details on available htcondor chart values is [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable/htcondor))

```yaml
        condorHost: {{ condor_host }}
        ccbHost: {{ ccb_address }}
        proxyCacheHost: {{ k8s_master_ip }}
        ttsCache:
          image: dodasts/tts-cache
          tag: v0.1.3-k8s-12
          iamToken: {{ iam_token }}
          iamClientId: CHANGEME 
          iamClientSecret: CHANGEME 
        htcSchedd:
          image: {{ htcondor_docker_image }}
          tag: v0.1.0-k8s-schedd-3
          networkInterface: {{ schedd_netinterface }}
          persistence:
            storageClass: local-path
        htcMaster:
          image: {{ htcondor_docker_image }}
          tag: v2.0.0
          networkInterface: {{ condor_host }}
        htcWn:
          image: {{ htcondor_docker_image }}
          tag: v2.0.0
        nfs:
          enabled: false
        cvmfs:
          enabled: false 
```

Field included in `{{  .. }}` will be filled up by the InfrastructureManager, so usually you don't hva to touch anything here.
`iamClientId` and `iamClientSecret` are the secrets of the IAM client used for exchange your access token with the Token Translation Service to obtain the X509 proxy. If you don't know how to get one, you can consider to contact us and get a demo one.

### Deployment

To start your deployment:

```bash
dodas create dodas-templates/templates/applications/k8s/template-htcondor.yaml
```

The output should be like this:

```bash
    validate called
    Template OK
    Template: dodas-templates/templates/applications/k8s/template-htcondor.yml
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
{"outputs": {"k8s_endpoint": "https://90.147.75.134:30443",
                    "user_registration": "http://90.147.75.136:48080"}}
```

Then, to access the k8s dashboard go to https://90.147.75.134:30443 .

To log into the K8s master and use kubernetes CLI (only if your master has a reachable IP):

```bash
dodas login <infID> 0
```

> If you need a quick introduction to k8s cli and feature to understand how to debug and manage pods and deployments. You'll find useful this [link](https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/)

### Registering new users for submission

A new user can register to submit jobs on the cluster via a simple web application exposed on the address shown by `dodas get output <infID>`.

You will need to provide your IAM username and a valid token to be automatically registered to the cluster.


### Submit a job

Please refer to [the user guide](condor-user.md) for this.