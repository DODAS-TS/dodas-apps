#  Dynamic On Demand Analysis Service

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

As introduced, DODAS manages container based applications and thus it relies on container orchestration for application deployment and management.The architecture has been built on top Kubernetes.The integration of Kubernetes resources in the DODAS is done via: 

- The creation of a plain Kubernetes cluster through a configurable Ansible role that takes care of all the needed steps from the initialization with “kubeadm” tool until the deployment of the kubernetes dashboard or metric server.
- The deployment of the applications that leverages the templating capabilities of Helm. A full integration of Helm with TOSCA is provided although the capability to run Helm on top of any pre-existing kubernetes instance has also been preserved. 

The applications are structured in such a way that, through the very same base template structure, different flavors of the same cluster can be deployed. For instance one can activate a certain type of shared filesystem to be used by putting a flag at Helm configuration level (so called “Helm values”). In addition multiple applications can be combined as needed with the Helm dependency system, where the child application will wait for the parent to be completely deployed before starting its own installation.
The Helm charts integration in the TOSCA template has been possible thanks to the usage of Ansible roles which take care of compiling Helm values only when the cluster has been automatically created and thus all the parametrized information are known. All the produced charts are documented following the best practices adopted by official projects in the Helm, so that anyone interested can easily fix or add features to the existing charts  [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable).


![DODAS deployment schema](https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/k8s_dodas.png)

The complete flow can be summarized as follow:
- Admins authenticate with the Infrastructure Manager:
  - using either username and password or a IAM access token
- IM uses the TOSCA template provided by the admin to deploy:
    - a k8s cluster
         - using the k8s ansible role [here](https://github.com/DODAS-TS/ansible-role-kubernetes)
         - also k3s availabel [here](https://github.com/DODAS-TS/ansible-role-k3s)
  - one or more helm charts on top of it:
    - using the helm install ansible role [here](https://github.com/DODAS-TS/ansible-role-helm):
        - kubectl create of any manifest is also supported by an [ansible role](https://github.com/DODAS-TS/ansible-role-kubecreate)
  - any other action supported or integrated into a tosca node type

## Quick start

> Before starting pleas note that all the DODAS templates uses the helm charts to deploy application on top of Kubernetes. You can find the helm chart defined and documented [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable).
Therefore **all applications can be installed also on top of any pre-existing k8s instance with [Helm](https://helm.sh/)**.

In this quick-start guide you will learn to use the basic functionalities and deployments modes of DODAS. As an example you will be guided through the creation of a kubernetes cluster with an instance of Jupyter and Spark.

### Requirements

- IAM credentials for accessing the Enabling Facility resources (you can skip this if you are not going to use the INFN infrastructure, e.g. for development instance described later):
    - Register to the IAM-DODAS service by accessing the service [here](https://dodas-iam.cloud.cnaf.infn.it). You can use your IdP because IAM-DODAS supports eduGAIN identity federation. The first registration will require the approval from the DODAS admins.
- oidc-agent installed and configured ([instructions here](setup-oidc.md)):
    - you can skip this if you are not going to use the INFN infrastructure, e.g. for development instance described later
- dodas client installed  ([instructions here](dodas-client.md))
- access to a cloud provider
- curl
- condor client for testing

### Deployment modes

To proceed with an end-to-end deployment from the infrastructure creation to the application setup we propose two approaches:

- using the **[INFN mantained infrastructure](https://dodas-ts.github.io/dodas-templates/quick-start-community/)** (part of the Enabling facility offer, requires a free registration for evaluation purpose [here](https://dodas-iam.cloud.cnaf.infn.it))
- a **[standalone setup](https://dodas-ts.github.io/dodas-templates/quick-start/)** where the needed componentes will be deployed on a docker container. Suggested for a development/playground usage.

## Supported apps

* Full-fledged HTCondor cluster:
    * [K8s setup + HTCondor deployment](condor.md)
    * [HTCondor deployment on pre-existing K8s cluster](condor-helm.md)
* Spark cluster with JupyterHub Kubespawner ([under construction](applications.md#spark))
    * [Using INFN facility](quick-start-community.md)
    * [Standalone setup](quick-start.md)
* CachingOnDemand ([under construction](applications.md#cachingondemand))
* IAM-integrated MINIO S3 instance (under construction)

## Developers guide

### Preview feature: DODAS Kubernetes operator

If you already have a Kubernetes cluster and you want to manage your infrastructures as Kubernetes resources the [DODAS Kubernetes operator](https://github.com/DODAS-TS/dodas-operator/) is what you are looking for.

Please refer to the documentation [here](https://dodas-ts.github.io/dodas-operator/) for a quick start guide.

### From HELM to template
If you are interested in **package your working helm chart in a template** you can find useful [this section](https://dodas-ts.github.io/dodas-templates/from-helm2tosca/).

### Roadmap

- WN pod Autoscaler based on condor_q
- Cluster autoscaling based on monitoring metrics
- HTCondor integration wiht IAM

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

## Acknowledgement

**This work is co-funded by the EOSC-hub project (Horizon 2020) under Grant number 777536.**                          

![EU logo](https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/eu-logo.jpeg)                              
![EOSC hub logo](https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/eosc-hub-web.png)


## Contact us

DODAS Team provides two support channels, email and Slack channel.

- **mailing list**: send a message to the following list dodas-support@lists.infn.it
- **slack channel**: join us on [Slack Channel](https://dodas-infn.slack.com/archives/CAJ6VG71A)
