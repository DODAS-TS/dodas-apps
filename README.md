#  Dynamic On Demand Analysis Service

<p align="left">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/logo.png" width="80" height="80" />
<img src="https://travis-ci.org/DODAS-TS/dodas-apps.svg?branch=master" />
</p>

## What's DODAS

Dynamic On Demand Analysis Service (DODAS) is a Platform as a Service tool built combining several solutions and products developed by the [INDIGO-DataCloud](https://www.indigo-datacloud.eu/) H2020 project and now part of the [EOSC-hub H2020](https://www.eosc-hub.eu/) Project.

### What you can do with DODAS?

DODAS allows to instantiate on-demand complex infrastructures over any cloud with almost zero effort and with very limited knowledge of the underlying technical details. In particular DODAS provides the end user with all the support to deploy from scratch a variety of solution dedicated (but not limited) to scientific data analysis. For instance, with pre-compiled templates the users can create a K8s cluster and deploy on top of it their preferred Helm charts all in one step.
DODAS provides three principal baselines ready to be used and to be possibly extended:

- an **HTCondor batch system**
- a **Spark+Jupyter** cluster for interective and big-data analysis
- a **Caching on demand** system based on XRootD

<p align="center">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/dodas.png" width="400" height="300" />
</p>


#### DODAS targets multiple users:
- Researchers possibly with requirement
specific workflows,
- Big Communities, Small groups
- Resource Providers

#### Designed to be experiment agnostic

- Flexible enough to support multiple and diverse use cases Highly Customizable to accommodate needs from diverse communities
- Built on top of modern industry standards

#### Commuties are already adopting DODAS

DODAS has been integrated by the Submission Infrastructure of Compact Muon Solenoid CMS, one of the two bigger and general purposes experiments at LHC of CERN, as well as by the Alpha Magnetic Spectrometer AMS-02 computing environment.

![DODAS schema](https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/evolution.png)

DODAS, as a Thematic Services in the context of EOSC-hub project, is financially supported by European Union’s Horizon 2020 research and innovation programme, grant agreement RIA 777536.

You can find a more detailed overview of the stack [here](in-depth.md)

## Quick start

> Before starting pleas note that all the DODAS templates uses the helm charts to deploy application on top of Kubernetes. You can find the helm chart defined and documented [here](https://github.com/DODAS-TS/helm_charts/tree/master/stable).
Therefore **all applications can be installed also on top of any pre-existing k8s instance with [Helm](https://helm.sh/)**.

In the [quick-start](quick-index.md) guide you will learn to use the basic functionalities and deployments modes of DODAS. As an example you will be guided through the creation of a kubernetes cluster with an instance of Jupyter and Spark.

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


## DODAS adopters

<p align="left">
<a href="community_cms">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/cms.png" width="100" height="100" />
</a>
<a href="community_ams">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/ams.png" width="80" height="120" />
</a>
<a href="community_fermi">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/fermi.png" width="100" height="100" />
</a>
</p>

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

<p align="left">
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/eu-logo.jpeg" width="140" height="100" />
<img src="https://github.com/DODAS-TS/dodas-templates/raw/master/docs/img/eosc-hub-web.png" width="400" height="100" />
</p>

## Publications and presentations

### Papers

-  D. Spiga et al. “DODAS: How to effectively exploit heterogeneous clouds for scientific computations”, PoS(ISGC 2018 & FCDD)024, DOI: [https://doi.org/10.22323/1.327.0024](https://doi.org/10.22323/1.327.0024)
- Using DODAS as deployment manager for smart caching of CMS data management system (ACAT, 2019), D. Spiga et al. Sep.2019
- Exploiting private and commercial clouds to generate on-demand CMS computing facilities with DODAS,  [https://doi.org/10.1051/epjconf/201921407027](https://doi.org/10.1051/epjconf/201921407027)


### Training and talks
- [The DODAS experience with the integration of multiple scientific communities and infrastructures](https://confluence.egi.eu/download/attachments/68223757/DODAS-EOSC-Week_Spiga.pdf?version=1&modificationDate=1589828853452&api=v2)
- [DODAS: How to effectively exploit heterogeneous clouds for scientific computations](http://indico4.twgrid.org/indico/event/4/session/19/contribution/29)
- [Exploiting private and commercial clouds to generate on-demand CMS computing facilities with DODAS](https://indico.cern.ch/event/587955/contributions/2937198/attachments/1682105/2702791/CHEP-2018-Spiga.pdf)
- [BoF: HPC, Containers and Big Data Analytics: How can Cloud Computing contribute to the New Challenges](https://2018.isc-program.com/?page_id=10&id=bof138&sess=sess357)
- [The AMS and DAMPE computing models and their integration into DODAS](https://agenda.infn.it/materialDisplay.py?contribId=116&sessionId=17&materialId=slides&confId=15310)
- [Training event in the context of SOS18 school](https://agenda.infn.it/event/15534/sessions/5373/#20180920)
- [INFN Training event](https://agenda.infn.it/event/19049/timetable/#20190916)
- [Training course on Batch As a System](https://agenda.infn.it/event/20268/timetable/#20191125)
- [Training course on Big Data Clusters](https://agenda.infn.it/event/20847/timetable/#20191209)
- [Using DODAS as deployment manager for smart caching of CMS data management system](https://indico.cern.ch/event/708041/contributions/3276221/)
- [Dynamic On Demand Analysis Service](https://events.ego-gw.it/indico/getFile.py/access?contribId=11&resId=0&materialId=slides&confId=77)
- [Vacuum model for job execution](https://indico.cern.ch/event/759388/contributions/3361772/attachments/1815562/2968683/20190321-mcnab-vacuum.pdf)
- [DODAS as no CE solution](https://indico.egi.eu/indico/event/4431/session/16/contribution/99)
- [The DODAS Experience on the EGI Federated Cloud](https://indico.cern.ch/event/773049/contributions/3473791/attachments/1937555/3211482/CHEP2019-DODAS_EGI.pdf)
- [Dynamic integration of distributed, Cloud-based HPC and HTC resources using JSON Web Tokens and the INDIGO IAM Service](https://indico.cern.ch/event/773049/contributions/3473805/attachments/1931644/3211480/CHEP19-CnafParma.pdf)
- [Talk at K8s WLCG](https://indico.cern.ch/event/739899/contributions/3662113/attachments/1959839/3256804/DODAS_K8S_pre-gdb.pdf )


## Contact us

DODAS Team provides two support channels, email and Slack channel.

- **mailing list**: send a message to the following list dodas-support@lists.infn.it
- **slack channel**: join us on [Slack Channel](https://dodas-infn.slack.com/archives/CAJ6VG71A)
