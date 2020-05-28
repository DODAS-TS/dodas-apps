## Available applications

All of these templates uses the helm charts defined and documented [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable).
Therefore **all the following applications can be installed as they are on top of any k8s instance with [Helm](https://helm.sh/)**

### K8s as a service

One option that you have is to use IM for deploying a k8s cluster on demand using the following templates:

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

### CachingOnDemand

XCache description is available in this article [here](https://iopscience.iop.org/article/10.1088/1742-6596/513/4/042044/pdf).

You can look at the [official XrootD documentation](http://xrootd.org/docs.html) for detailed information about the XRootD tool:

- [basic configuration](http://xrootd.org/doc/dev47/xrd_config.htm)
- [cmsd configuration](http://xrootd.org/doc/dev45/cms_config.htm)
- [proxy file cache](http://xrootd.org/doc/dev47/pss_config.htm)

With these templates you can deploy Caching On Demand on top of either k3s or k8s:

- [CachingOnDemand on k3s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k3s/template-cachingondemand.yml)
- [CachingOn Demand on k8s](https://github.com/DODAS-TS/dodas-templates/tree/master/templates/applications/k8s/template-cachingondemand.yml)