# Federate your cluster

## Requirements

- Two working HTCondor clusters instatiated either with DODAS ([this guide](condor.md)) or with plain HELM ([this other guide](condor-helm.md)).
- Working kubectl for the 2 clusters
    - either logging on the k8s master node or having a valid one on you computer

We will call as `master` the cluster that will distribute the jobs to the second one (`slave`)

## Configure the master cluster

Using the k8s context of the master cluster, edit its schedd configmap:

```bash
kubectl edit configmap scheddconfigd
```

Then add the following lines to the content:

```text
FLOCK_TO = <public address of the slave Collector node>
FLOCK_COLLECTOR_HOSTS = $(FLOCK_TO)
FLOCK_NEGOTIATOR_HOSTS = $(FLOCK_TO)
HOSTALLOW_NEGOTIATOR_SCHEDD = $(COLLECTOR_HOST), $(FLOCK_NEGOTIATOR_HOSTS)
```

> **N.B**: after the change you have to restart the schedd pod

## Configure the master cluster

Using the k8s context of the slave cluster, edit its collector configmap:

```bash
kubectl edit configmap ccbconfigd
```

Then add the following lines to the content:

```text
FLOCK_FROM = <public address of the master schedd>
```

> **N.B**: after the change you have to restart the collector pod

All done now. Give the system few minutes to adapt and you should be able to see jobs coming to the slave clusters soon.