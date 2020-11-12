# Deploy HTCondor cluster on K8s with HELM

## Requirements

Before starting be sure to have all the [requirements](./README.md#requirements) satisfied.

In addition you will need:

- HELM cli installed ([instructions here](https://helm.sh/docs/intro/install/))
- condor client for testing

## Get your access token

This step should be as simple as:

```bash
oidc-token dodas
```

## Add the DODAS helm repo

```bash
helm repo add dodas https://dodas-ts.github.io/helm_charts
helm repo update
```

## Label you collector and schedd node

The condor Master and CCB will be located on nodes with the following label: `condor=ccb`
The schedd will have the label: `condor=schedd`.

You can set the label of a node with:
```bash
kubectl label nodes <node name> condor=ccb
```

Both nodes will need to have a publicIP with ports 9618 and \[31024, 32048\]  opened.
For user registration schedd will also need prot 48080.

## HELM chart Values

A minumum setup can be achieved putting into a yaml file (e.g. values.yaml) the following values:

```yaml
condorHost: <master public IP>
ccbHost: <master public IP>
proxyCacheHost: <master private IP>
ttsCache:
    image: dodasts/tts-cache
    tag: v0.1.3-k8s-12
    iamToken: < your valid access token >
    iamClientId: CHANGEME 
    iamClientSecret: CHANGEME 
htcSchedd:
    image: dodasts/htcondor
    tag: v0.1.0-k8s-schedd-3
    networkInterface: < schedd public IP >
    persistence:
        storageClass: local-path
htcMaster:
    image:  dodasts/htcondor
    tag: v2.0.0
    networkInterface: <master public IP>
htcWn:
    image:  dodasts/htcondor
    tag: v2.0.0
nfs:
    enabled: false
cvmfs:
    enabled: false 
```

`iamClientId` and `iamClientSecret` are the secrets of the IAM client used for exchange your access token with the Token Translation Service to obtain the X509 proxy. If you don't know how to get one, you can consider to contact us and get a demo one.

> For more info on HELM you can navigate their [documentation](https://helm.sh/docs/), while details on available htcondor chart values is [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable/htcondor)


## Deploy your HELM Chart

At this point deploying your helm chart will be as simple as: 

```bash
helm install htcondor  --values values.yaml dodas/htcondor
```

When you see everything running on your k8s cluster you can proceed with testing the user registration and a first test job.

> If you need a quick introduction to k8s cli and feature to understand how to debug and manage pods and deployments. You'll find useful this [link](https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/)

### Registering new users for submission

A new user can register to submit jobs on the cluster via a simple web application exposed on `http://<schedd IP>:48080/register`.

You will need to provide your IAM username and a valid token to be automatically registered to the cluster.


### Submit a job

Please refer to [the user guide](condor-user.md) for this.
