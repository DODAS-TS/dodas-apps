# DODAS: TOSCA templates for applicaton

<p align="center">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/logo.png" width="200" height="200" />
</p>

![travis build](https://travis-ci.org/DODAS-TS/dodas-templates.svg?branch=master)

## What's DODAS

Dynamic On Demand Analysis Service (DODAS) is a Platform as a Service tool built combining several solutions and products developed by the [INDIGO-DataCloud](https://www.indigo-datacloud.eu/) H2020 project and now part of the [EOSC-hub H2020](https://www.eosc-hub.eu/) Project.

DODAS allows to instantiate on-demand complex infrastructures over any cloud with almost zero effort and with very limited knowledge of the underlying technical details. In particular DODAS provides the end user with all the support to deploy from scratch a variety of solution dedicated (but not limited) to scientific data analysis. For instance, with pre-compiled templates the users can create a K8s cluster and deploy on top of it their preferred Helm charts all in one step.
DODAS provides three principal baselines ready to be used and to be possibly extended:

- an **HTCondor batch system**
- a **Spark+Jupyter** cluster for interective and big-data analysis
- a **Caching on demand** system based on XRootD

DODAS has been integrated by the Submission Infrastructure of Compact Muon Solenoid CMS, one of the two bigger and general purposes experiments at LHC of CERN, as well as by the Alpha Magnetic Spectrometer AMS-02 computing environment.

DODAS, as a Thematic Services in the context of EOSC-hub project, is financially supported by European Union’s Horizon 2020 research and innovation programme, grant agreement RIA 777536.

### The purpose

The mission of DODAS is to act as a cloud enabler for scientists seeking to easily exploit distributed and heterogeneous clouds to process, manipulate or generate data. Aiming to reduce the learning curve, as well as the operational cost of managing community specific services running on distributed cloud, DODAS completely automates the process of provisioning, creating, managing and accessing a pool of heterogeneous computing and storage resources.

Within the EOSC-hub project "DODAS - Thematic Service" is providing both the **PaaS core services** and an **Enabling Facility** provided by Cloud@CNAF and Cloud@ReCaS-Bari. Even though DODAS PaaS core layer can be used to exploit any cloud in a standalone manner, we foresee that a user might benefit of a freely accessible Enabling Facility where to test a customisation and/or simply try out how DODAS behaves etc.

The core component responsible for the deployment creation and management is the [InfrastructureManager](https://www.grycap.upv.es/im/index.php)(IM).

> IM is a tool that ease the access and the usability of IaaS clouds by automating the VMI selection, deployment, configuration, software installation, monitoring and update of Virtual Appliances. It supports APIs from a large number of virtual platforms, making user applications cloud-agnostic. In addition it integrates a contextualization system to enable the installation and configuration of all the user required applications providing the user with a fully functional infrastructure.

### Components

![DODAS deployment schema](https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/k8s_dodas.png)

- Admins authenticate with the Infrastructure Manager
  - using either username and password or a IAM access token
- IM uses the TOSCA template provided by the admin to deploy:
  - a k8s cluster
    - using the k8s ansible role [here](https://github.com/DODAS-TS/ansible-role-kubernetes)
      - also k3s availabel [here](https://github.com/DODAS-TS/ansible-role-k3s)
  - one or more helm charts on top of it
    - using the helm install ansible role [here](https://github.com/DODAS-TS/ansible-role-helm)
      - kubectl create of any manifest is also supported by an [ansible role](https://github.com/DODAS-TS/ansible-role-kubecreate)
  - any other action supported or integrated into a tosca node type

## Quick start

### DODAS CLI

To start playing with DODAS templates we provide a two quick start guides:

- using the **[community instance of IM](https://dodas-ts.github.io/dodas-templates/quick-start-community/)** (part of the Enabling facility offerr, requires a free registration for evaluation purpose [here](https://dodas-iam.cloud.cnaf.infn.it))
- a **[standalone setup](https://dodas-ts.github.io/dodas-templates/quick-start/)** where IM will be deployed on a docker container

### DODAS Kuberntes operator

If you already have a Kubernetes cluster and you want to manage your infrastructures as Kubernetes resources the [DODAS Kubernetes operator](https://github.com/DODAS-TS/dodas-operator/) is what you are looking for.

Please refer to the documentation [here](https://dodas-ts.github.io/dodas-operator/) for a quick start guide.

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

## Developers guide

If you are interested in **package your working helm chart in a template** you can find useful [this section](https://dodas-ts.github.io/dodas-templates/from-helm2tosca/).

### Contributing

1. create a branch
2. upload your changes
3. create a pull request

Thanks!

### Render the page using Mkdocs

You will need [mkdocs](https://www.mkdocs.org/) installed on your machine. You can install it with pip:

```bash
pip install mkdocs mkdocs-material
```

To start a real time rendering of the doc just type:

```bash
mkdocs serve
```

The web page generated will be now update at each change you do on the local folder.

## Contact us

DODAS Team provides two support channels, email and Slack channel.

- **mailing list**: send a message to the following list dodas-support@lists.infn.it
- **slack channel**: join us on [Slack Channel](https://dodas-infn.slack.com/archives/CAJ6VG71A)
