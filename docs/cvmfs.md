# Mount cvmfs on worker nodes

## Requirements

To set cvmfs mountpoints on the worker node you should apply simple changes to the HTCondor HELM values indicated either for DODAS ([this guide](condor.md)) or or plain HELM ([this other guide](condor-helm.md)).

## Configuration

You can simply add the following values to the HELM values file to mount different CVMFS repositories on the WNs:

```yaml
cvmfs:
    enabled: true 
    image: cloudpg/cvmfs
    tag: k8s-dev
    pullPolicy: IfNotPresent
    replicas: 1

    # List of repos to be mounted
    repoList: ams.local.repo ams.cern.ch sft.cern.ch

    privKey: 
    - name: ams
        filename: ams.local.repo.pub
        path: \"keys/ams.local.repo\"
        content: | 
        -----BEGIN PUBLIC KEY-----
            <CHANGEME>
        -----END PUBLIC KEY-----
    defaultLocalConfig:
    - file: ams.local.repo.conf
        content: |
        CVMFS_SERVER_URL=http://<CHANGEME>/cvmfs/ams.local.repo
        CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/ams.local.repo/ams.local.repo.pub
        CVMFS_HTTP_PROXY=DIRECT
        CVMFS_DEBUGFILE=/tmp/cvmfs_ams_local.log
    - file: ams.cern.ch.conf
        content: |
        CVMFS_SERVER_URL=http://cvmfs-stratum-one.cern.ch/cvmfs/ams.cern.ch
        CVMFS_HTTP_PROXY=DIRECT
        CVMFS_DEBUGFILE=/tmp/cvmfs_ams_cern.log
    - file: sft.cern.ch.conf
        content: |
        CVMFS_SERVER_URL=http://cvmfs-stratum-one.cern.ch/cvmfs/sft.cern.ch
        CVMFS_HTTP_PROXY=DIRECT
        CVMFS_DEBUGFILE=/tmp/cvmfs_sft.log
```