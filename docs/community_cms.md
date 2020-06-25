# Compact Muon Solenoid at LHC

> **N.B.** this page is under construction

## Prerequisites

In the basic implementation has been built on the following assumptions 

1. There is **no Computing Element**. Worker nodes \(HTCondor startd processes\) start up as a docker container over Mesos cluster, and auto-join the HTCondor Global-Pool of CMS
2. Data I/O is meant to rely on AAA xrootd read rule 
   1. although there is not technical limitation preventing the usage of local storages.
3. stage-out relies on a Tier site of CMS, e.g. INFN relies on TI\_IT\_CNAF. The result is something like this in the site local config  


   ```text
   url="trivialcatalog_file:/cvmfs/cms.cern.ch/SITECONF/T1_IT_CNAF/PhEDEx/storage.xml?protocol=srmv2"/>
   ```

This imply to accomplish with the following pre-requisites: 

* Requires Submission Infrastructure \(SI\) L2s authorization for Global-Pool access. In order to being authorized you must belong to the CMS Collaboration and provide a DN and CMS Site Name. SI will use these info to define the proper mapping in the match-maker. 
  * Get a DN from X.509 Certificate you can retrieve from the [Token Translation Service ](https://dodas-tts.cloud.cnaf.infn.it/).  1. Click to request a x509.  2. A pop-up window will allow you to download the certificate PEM file. At that point you should run  `openssl x509 -noout -in <certificate.pem> -subject` 3. and you will obtain something like  `subject= /C=IT/O=CLOUD@CNAF/CN=xxxxxxx@dodas-iam`
  * Define a name for your ephemeral CMS Site: e.g.  `T3_XX_Opportunistic_KK`
* If you want to be visible in the Dashboard \(this is ONLY true for the old-fashioned [Dashboard](http://dashboard.cern.ch/cms/)\) you need to notify the dashboard support team informing that you need the following mapping among Site Name and SyncCE  `Site Name == T3_XX_Opportunistic_KK  SyncCE == T3_XX_Opportunistic_KK`
  * NOTE : This is needed because DODAS does not deploy a cluster which relies on a Computing Element. 
  * You need to provide a job id to the CERN monitoring team.

## Long Running Services 

Once done all of this, you should be able to configure everything trhough a set con HELM values to be passed to the HTCondor HELM chart. Similarly to what indicated in [DODAS HTCondor guide](condor.md) or [HELM HTCondor guide](condor-helm.md).

The CMS template deploys the following services and components:   
- squid proxy  
- token translation service
   - proxy renewal cronJob   
- worker node \(HTCondor StartD\) 
   - CMS Trivial File Catalogue
- CVMFS

Docker image files are available [here](https://github.com/DODAS-TS/dodas-docker-images).

## Launching a DODAS instance of HTCondor for CMS

To lauch an instance of CMS StartDs on K8s you should apply simple changes to the HTCondor HELM values indicated either for DODAS ([this guide](condor.md)) or  plain HELM ([this other guide](condor-helm.md)).

The value file template looks as follows:

```yaml
TODO SPIGA
```

TODO: link a template


## Submitting CRAB jobs for DODAS CMS Site 

In order to submit CRAB jobs with proper classad parameters which guarantee the matching, you need to add this extra line in the configuration file of CRAB: 

```text
config.Debug.extraJDL = [ '+DESIRED_Sites="T3_XX_XY_KK"','+JOB_CMSSite="T3_XX_XY_KK"','+AccountingGroup="highprio.<YOUR_LXPLUS_LOGIN>"' ]
```

There is no any other change you need to do. 

