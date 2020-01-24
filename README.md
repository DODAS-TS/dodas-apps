# DODAS: TOSCA templates for applications

## Requirements
Register to the IAM-DODAS service by accessing the service here. You can use your IdP because IAM-DODAS supports eduGAIN identity federation.
The first registration will require the approval from the DODAS admins.

## Setting up dodas client

Get the latest client following instructions at https://dodas-ts.github.io/dodas-go-client/.


## Getting the token

Copy [```.dodas-template.yaml```](.dodas-template.yaml) and [```get_orchet_token.sh```](get_orchet_token.sh)

Run

```
sh get_orchent_token.sh
```
and put your Indigo IAM credentials in order to get your token which will be automatically put inside your newly created ```.dodas.yaml``` file. 

Now you are ready to deploy your application

## Available applications

### K8s as a service

### Spark
Apache Spark is a fast and general-purpose cluster computing system.

* http://spark.apache.org/

This chart will do the following:

* 1 x Spark Master with port 30808 exposed with a nodePort service (webUi)
* 1 x Jupyter notebook with port 30888 exposed with a nodePort service, with 2 executors
* All using Kubernetes Deployments

With these templates you can deploy Apache Spark on top of either k3s or k8s:
- [Spark on k3s](templates/applications/k3s/template-spark.yml)
- [Spark on k8s](templates/applications/k8s/template-spark.yml)

#### Quick start

```
dodas create /templates/applications/k8s/template-spark.yaml
```

To get the infrastructure ID (infID) of all your deployments
```
dodas list infIDs
```

To check the status of the deployment
```
dodas get status <infID>
```

And to get the output of the deployment
```
dodas get output <infID>
```

To log into one of the VM created by the deployment:
```
dodas login <infID> <vmID>
sudo su
```

### HTCondor
HTCondor is an open-source high-throughput computing software framework for coarse-grained distributed parallelization of computationally intensive tasks (https://research.cs.wisc.edu/htcondor/).

With these templates you can deploy HTCondor on top of either k3s or k8s:
- [HTCondor on k3s](templates/applications/k3s/template-htcondor.yml)
- [HTCondor on k8s](templates/applications/k8s/template-htcondor.yml)

### CachingOnDemand

XCache description is available in this article [here](https://iopscience.iop.org/article/10.1088/1742-6596/513/4/042044/pdf).

You can look at the [official XrootD documentation](http://xrootd.org/docs.html) for detailed information about the XRootD tool:

- [basic configuration](http://xrootd.org/doc/dev47/xrd_config.htm)
- [cmsd configuration](http://xrootd.org/doc/dev45/cms_config.htm)
- [proxy file cache](http://xrootd.org/doc/dev47/pss_config.htm)

With these templates you can deploy Caching On Demand on top of either k3s or k8s:
- [CachingOnDemand on k3s](templates/applications/k3s/template-cachingondemand.yml)
- [CachingOn Demand on k8s](templates/applications/k8s/template-cachingondemand.yml)


All of these templates uses the helm charts defined in https://github.com/DODAS-TS/helm_charts/tree/master/stable.