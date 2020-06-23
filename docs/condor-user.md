# Quick start for HTCondor cluster users

## Requirements

- The guide is made for CENTOS-7 machines
- Register an account [here](https://dodas-iam.cloud.cnaf.infn.it). You can use your IdP because IAM-DODAS supports eduGAIN identity federation. The first registration will require the approval from the DODAS admins.
    - wait for approval, if within 24h you do not receive any answer please send an email/slack message to the support
- [Setup OIDC-agent](setup-oidc.md)
- Install condor client, voms client and CA certificates:

```bash
yum -y install epel-release
cd /etc/yum.repos.d/ \
    && wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo \
    && wget http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor \
    && rpm --import RPM-GPG-KEY-HTCondor \
    && yum update -y && yum install -y condor-all-8.8.2
yum install -y voms-clients-cpp globus-proxy-utils fetch-crl
wget -O /etc/yum.repos.d/ca_CMS-TTS-CA.repo https://ci.cloud.cnaf.infn.it/view/dodas/job/ca_DODAS-TTS/job/master/lastSuccessfulBuild/artifact/ca_DODAS-TTS.repo
yum -y install ca_DODAS-TTS
fetch-crl -q

# Download doc material
git clone https://github.com/DODAS-TS/dodas-apps.git
cd dodas-apps
```

- [Dowload tts-cache service app](https://github.com/DODAS-TS/dodas-ttsInK8s/releases/download/v0.0.2/tts-cache) 

## Register on the schedd

Ask the cluster admins for the correct endpoint of the registration that usually will be in the form of:

```text
http://<schedd_ip>:48080/register
```

Go to that address and fill up the form with your username and a valid access token that you can obtain with:

```bash
oidc-token dodas
```

> N.B. this operation needs to be performed ONLY ONCE, while the following steps might need refreshing every now and then. Usually they will last for around 6 hours.

## Prepare your proxy

Retrieve your user proxy with:

```bash
./tts-cache --dump-proxy --token $TOKEN
```

Then check that you got a valid one:

```bash
voms-proxy-info --file /tmp/userproxy_`id -u`.pem
```

## Setup the environment

Once done with the registration you should setup the correct environment variables to contact the HTCondor cluster.
These are all the information you need to ask for at the cluster admin in case you are not one:

```bash
export X509_USER_PROXY=/tmp/userproxy_`id -u`.pem
export _condor_GSI_DAEMON_NAME=<X509 DN name of the creator of the cluster>
export _condor_COLLECTOR_HOST=<collector IP>
export _condor_SCHEDD_HOST=<schedd IP>
export _condor_SEC_DEFAULT_ENCRYPTION=REQUIRED
export _condor_SEC_CLIENT_AUTHENTICATION_METHODS=GSI
```

## Get the example submission files

You can find in `examples/htcondor` two files that are the script to be run as job (called `simple`) and the HTCondor submission file (`sub`).

So first of all go to the example directory

```bash
cd  examples/htcondor
```

Then take a look at the `simple` file that should look simple as:

```text
#!/bin/bash

sleep 100
echo $HOSTNAME
```

While a standard submit file (`sub`) should be in the form of:

```text
universe   = vanilla
executable = simple
log        = simple.log
output     = simple.out
error      = simple.error
+OWNER = "<your registration username here>"
queue
```

Where you should use the name that you indicated in the registration form.

You can take a look at [HTCondor user guide](https://htcondor.readthedocs.io/en/latest/users-manual/submitting-a-job.html) for more information on all the possible submission options.


## Submit your job

``` bash
condor_submit -spool sub
```

## Useful commands

```bash
# Check the status of the job in the queue
condor_q

# Check the cluster status
condor_status

# Check the job history
condor_history -h
```

