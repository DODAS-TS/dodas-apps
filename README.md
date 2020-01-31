# DODAS: TOSCA templates for applications

## Requirements

Register to the IAM-DODAS service by accessing the service [here](https://dodas-iam.cloud.cnaf.infn.it). You can use your IdP because IAM-DODAS supports eduGAIN identity federation.
The first registration will require the approval from the DODAS admins.

## Setting up dodas client

Get the latest client following instructions at [https://dodas-ts.github.io/dodas-go-client/](https://dodas-ts.github.io/dodas-go-client/).

## Getting the token

Follow instructions at [https://indigo-iam.github.io/docs/v/current/user-guide/getting-a-token.html](https://indigo-iam.github.io/docs/v/current/user-guide/getting-a-token.html).

Now you are ready to deploy your application.

## Available applications

All of these templates uses the helm charts defined at [https://github.com/DODAS-TS/helm_charts/tree/master/stable](https://github.com/DODAS-TS/helm_charts/tree/master/stable).

### K8s as a service

Deploy a k8s cluster on demand with:

- [k8s template](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/orchestrators/template-k3s.yml)
- [k3s template](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/orchestrators/template-k3s.yml)

### Spark

Apache Spark is a fast and general-purpose cluster computing system.

- [http://spark.apache.org/](http://spark.apache.org/)

This chart will do the following:

- 1 x Spark Master with port 30808 exposed with a nodePort service (webUi)
- 1 x Jupyter notebook with port 30888 exposed with a nodePort service, with 2 executors
- All using Kubernetes Deployments

With these templates you can deploy Apache Spark on top of either k3s or k8s:

- [Spark on k3s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k3s/template-spark.yml)
- [Spark on k8s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k8s/template-spark.yml)

### HTCondor

[HTCondor](https://research.cs.wisc.edu/htcondor/) is an open-source high-throughput computing software framework for coarse-grained distributed parallelization of computationally intensive tasks.

With these templates you can deploy HTCondor on top of either k3s or k8s:

- [HTCondor on k3s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k3s/template-htcondor.yml)
- [HTCondor on k8s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k8s/template-htcondor.yml)

### CachingOnDemand

XCache description is available in this article [here](https://iopscience.iop.org/article/10.1088/1742-6596/513/4/042044/pdf).

You can look at the [official XrootD documentation](http://xrootd.org/docs.html) for detailed information about the XRootD tool:

- [basic configuration](http://xrootd.org/doc/dev47/xrd_config.htm)
- [cmsd configuration](http://xrootd.org/doc/dev45/cms_config.htm)
- [proxy file cache](http://xrootd.org/doc/dev47/pss_config.htm)

With these templates you can deploy Caching On Demand on top of either k3s or k8s:

- [CachingOnDemand on k3s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k3s/template-cachingondemand.yml)
- [CachingOn Demand on k8s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k8s/template-cachingondemand.yml)

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
