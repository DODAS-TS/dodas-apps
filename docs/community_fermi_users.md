## Register in DODAS

https://dodas-iam.cloud.cnaf.infn.it/login

## Setup oidc-agent to get your token

https://dodas-ts.github.io/dodas-apps/setup-oidc/

## Register your user into the HTCondor Cluster

Behind Perugia-VPN go to the link below and insert your username and token (got from the point above):

http://141.250.7.32:48080/register


## Source the correct env

Login into the Fermi UI and create a folder for this quick start

```bash
mkdir test_condor_jobs
cd test_condor_jobs
```

## Get a valid proxy

Retrieve a valid token with `oidc-token dodas` and do the following:

```bash
export TOKEN=<your token>
tts-cache --dump-proxy --token $TOKEN
```

Check that the proxy is correct with:

```bash
voms-proxy-info --file /tmp/userproxy_`id -u`.pem
```

## Submit file

To submit a simple job running the following bash script saved on a file named `simple`:

```bash
#!/bin/bash

sleep 100
echo $HOSTNAME
```

you need to provide a submission file (named `sub` in this case):

```text
universe   = vanilla
executable = simple
log        = simple.log
output     = simple.out
error      = simple.error
+OWNER = "<YOUR USERNAME>"
queue
```

Then you can submit the job with:

```bash
condor_submit -spool sub
```

and check the status with the following commands

```bash
# Check the status of the job in the queue
condor_q

# Check the cluster status
condor_status

# Check the job history
condor_history -h
```

> **N.B.** you can find more examples and submission files [here](https://htcondor.readthedocs.io/en/latest/users-manual/submitting-a-job.html) or here for submitting [using python](https://research.cs.wisc.edu/htcondor/python_notebook_examples/HOWTO_Submit_bag_of_jobs.html)