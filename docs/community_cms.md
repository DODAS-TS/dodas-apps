# Compact Muon Solenoid at LHC

> **N.B.** this page is under construction

## Prerequisites

First of all you will need to register an account with [DODAS IAM](https://dodas-iam.cloud.cnaf.infn.it/) to be able to exchange a personal token with a globalpool trusted proxy. 

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

## Long Running Services 

Once done all of this, you should be able to configure everything trhough a set con HELM values to be passed to the [HTCondor HELM chart](https://github.com/DODAS-TS/helm_charts/tree/master/stable/cms).

The CMS template deploys the following services and components:   
- squid proxy  
- token translation service
   - proxy renewal cronJob   
- worker node \(HTCondor StartD\) 
   - CMS Trivial File Catalogue
- CVMFS

Docker image files are available [here](https://github.com/DODAS-TS/dodas-docker-images).

## Launching a DODAS instance of HTCondor for CMS

First of all, let's load the DODAS Helm Chart repository

```bash
helm repo add dodas https://dodas-ts.github.io/helm_charts
helm repo update
```

Then, to launch an instance of CMS StartDs on K8s you should apply simple changes to the HTCondor HELM values as you need.
The value file template looks as follows:

```yaml
htcondor:
  ttsCache:
    enabled: true
    image: ghcr.io/dodas-ts/tts-cache
    tag: v1.0.1
    iamToken: eyJra......LCcVE
    iamClientId: 1133....69bbc
    iamClientSecret: ILzMQEAl6a......rIe1cmgPQ
  schedd:
    enabled: false
  master:
    enabled: false
  squid:
    enabled: true
    image: dodasts/squid
    tag: v1.1.2-dodas
  cvmfs:
    enabled: true
    image: dodasts/cvmfs
    tag: v1.4-reloaded
    pullPolicy: IfNotPresent
    replicas: 1
    # # List of repos to be mounted
    repoList: cms.cern.ch  grid.cern.ch
    defaultLocalConfig:
      - file: cms.cern.ch.conf
        content: |
          export CMS_LOCAL_SITE=/etc/cvmfs/SITECONF
          CVMFS_HTTP_PROXY=http://localhost:3128
      - file: grid.cern.ch.conf
        content: \"CVMFS_HTTP_PROXY=http://localhost:3128\"
  wn:
    # Condor slot type
    slotType: cpus=1, mem=2000
    requests:
      memory: "1500M"
      cpu: 1
    replicas: 1
    image:
      name: dodasts/cms
      tag: latest
    args: /usr/local/bin/dodas.sh
    siteConfCMS:
      enabled: true
      numCPUS: 1
      files:
        - name: sitelocal
          path: JobConfig
          filename: site-local-config.xml
          content: |
            <site-local-config>
            <site name=\"{{cms_config_cms_local_site}}\">
            <event-data>
            <catalog url=\"trivialcatalog_file:/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx/storage.xml?protocol={{cms_input_protocol}}\"/>
            </event-data>
            <calib-data>
            <frontier-connect>
            <load balance=\"proxies\"/>
            <proxy url=\"http://localhost:3128\"/>
            <backupproxy url=\"http://cmsbpfrontier.cern.ch:3128\"/>
            <backupproxy url=\"http://cmsbproxy.fnal.gov:3128\"/>
            <server url=\"http://cmsfrontier.cern.ch:8000/FrontierInt\"/>
            <server url=\"http://cmsfrontier1.cern.ch:8000/FrontierInt\"/>
            <server url=\"http://cmsfrontier2.cern.ch:8000/FrontierInt\"/>
            <server url=\"http://cmsfrontier3.cern.ch:8000/FrontierInt\"/>
            </frontier-connect>
            </calib-data>
            <local-stage-out>
              <command value=\"{{cms_config_stageoutcommand}}\"/>
              <catalog url=\"trivialcatalog_file:/cvmfs/cms.cern.ch/SITECONF/{{cms_config_stageoutsite}}/PhEDEx/storage.xml?protocol={{cms_config_stageoutprotocol}}\"/>
              <se-name value=\"srm-eoscms.cern.ch\"/>
              <phedex-node value=\"{{cms_config_phedexnode}}\"/>
            </local-stage-out>
            <fallback-stage-out>
              <se-name value=\"t2-srm-02.lnl.infn.it\"/>
              <phedex-node value=\"{{cms_config_fallback_phedexnode}}\"/>
              <lfn-prefix value=\"{{cms_config_fallback_lfn_prefix}}\"/>
              <command value=\"{{cms_config_fallback_command}}\"/>
            </fallback-stage-out>
            </site>
            </site-local-config>
        - name: storage
          path: PhEDEx
          filename: storage.xml
          content: |
            <storage-mapping>
            <!-- AAA xrootd read rule -->
            <lfn-to-pfn protocol=\"xrootd\"
                    destination-match=\".*\"
                    path-match=\"/+store/(.*)\"
                    result=\"root://{{cms_xrd_readserver}}//store/$1\"/>
            <!-- Onedata read rule -->
            <lfn-to-pfn protocol=\"onedata\"
                    destination-match=\".*\"
                    path-match=\"/(.*)\"
                    result=\"/mnt/onedata/{{cms_input_path}}/$1\"/>
            </storage-mapping>

```

Please notice that you might need to request a valid IAM client ID and secret to a DODAS administrator if this is the first time that you instatiate a service with DODAS. 

Finally you can install the chart:

```bash
helm install dodas-cms dodas/cms-experiment --values values.yaml
```


## Submitting CRAB jobs for DODAS CMS Site 

In order to submit CRAB jobs with proper classad parameters which guarantee the matching, you need to add this extra line in the configuration file of CRAB: 

```text
config.Debug.extraJDL = [ '+DESIRED_Sites="T3_XX_XY_KK"','+JOB_CMSSite="T3_XX_XY_KK"','+AccountingGroup="highprio.<YOUR_LXPLUS_LOGIN>"' ]
```

There is no any other change you need to do. 

