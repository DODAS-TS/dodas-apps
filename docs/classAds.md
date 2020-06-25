# Set WN flavor with ClassAds

## Requirements

- A working HTCondor clusters instatiated either with DODAS ([this guide](condor.md)) or with plain HELM ([this other guide](condor-helm.md)).
- Working kubectl for the cluster
    - either logging on the k8s master node or having a valid one on you computer


## Configure a machine ClassAd

Using the k8s context of the master cluster, edit its schedd configmap:

```bash
kubectl edit configmap wnconfigd
```

Then add the following lines to the content:

```text
Group = "Fermi"
STARTD_ATTRS = $(STARTD_ATTRS) Group
```

> **N.B**: after the change you have to restart the wn pods

Users can now select their WN flavor by following the indications [here](https://htcondor-wiki.cs.wisc.edu/index.cgi/wiki?p=HowToInsertCustomClassAdIntoJobs)
