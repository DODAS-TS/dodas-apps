# FERMI 

> **N.B.** this page is under construction

## Components

TODO

## Launching a DODAS instance of HTCondor for CMS

To lauch an instance of Fermi HTCondor cluster on K8s you should apply simple changes to the HTCondor HELM values indicated either for DODAS ([this guide](condor.md)) or  plain HELM ([this other guide](condor-helm.md)).

The value file template looks as follows:

```yaml
condorHost: {{ condor_host }}
ccbHost: {{ ccb_address }}
proxyCacheHost: {{ k8s_master_ip }}
ttsCache:
    image: dodasts/tts-cache
    tag: v0.1.3-k8s-12
    iamToken: {{ iam_token }}
    iamClientId: 99f7152a-...-8f27dcbe67e0 
    iamClientSecret: AIEx7S3vA-...-b2lQ8i4Qdv_38o 
htcSchedd:
    image: {{ htcondor_docker_image }}
    tag: v0.1.0-k8s-schedd-3
    networkInterface: {{ schedd_netinterface }}
    persistence:
    storageClass: local-path
    size: 200Gi
    claimSize: 199Gi

    # local-storage for k8s, local-path for k3s
    storageClass: local-storage

    # persistence of the schedd spool directory
    mountPath: /var/lib/condor/spool/

    # mount options
    options: |
        local:
        path: \"/mnt/spool/\"
        nodeAffinity:
        required:
            nodeSelectorTerms:
            - matchExpressions:
                - key: condor
                operator: In
                values:
                    - schedd
htcMaster:
    image: {{ htcondor_docker_image }}
    tag: v0.1.0-k8s-schedd-3
    networkInterface: {{ condor_host }}
htcWn:
    image: {{ htcondor_docker_image }}
    tag: v0.1.0-k8s-fermi-2
    persistentVolume:
    pv:
        name: "data-rclone-1"
        spec: |
        accessModes:
        - ReadWriteMany
        capacity:
            storage: 800Gi
        storageClassName: rclone
        csi:
            driver: csi-rclone
            volumeHandle: data-id
            volumeAttributes:
            remote: "s3"
            remotePath: "home"
            s3-provider: "Minio"
            s3-endpoint: "https://<CHANGEME>:9000"
            s3-access-key-id: "CHANGEME"
            s3-secret-access-key: "CHANGEME"
            no-check-certificate: "true"
            vfs-cache-mode: "writes"
            vfs-cache-max-size: "4G"
            buffer-size: 2G
            vfs-read-chunk-size: "512k"
            vfs-read-chunk-size-limit: "10M"
            no-modtime: "true"
    pvc:
        name: "data-rclone-1"
        mountPath: "/home/Volume_Fermi"
        spec: |
        accessModes:
        - ReadWriteMany
        resources:
            requests:
            storage: "799Gi"
        storageClassName: rclone
        volumeName: data-rclone-1
        selector:
            matchLabels:
            name: data-rclone-1

    # Resource limits and requests
    cpu:
    request: 0.8
    limit: 1.5
    ram:
    request: 1024Mi
    limit: 2048Mi

    # Condor slot type
    slotType: cpus=1, mem=200

cvmfs:
    enabled: true 
    image: cloudpg/cvmfs
    tag: k8s-dev
    pullPolicy: IfNotPresent
    replicas: 1

    # List of repos to be mounted
    repoList: fermi.local.repo 

    privKey: 
    - name: fermi
        filename: fermi.local.repo.pub
        path: \"keys\"
        content: | 
        -----BEGIN PUBLIC KEY-----
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5Rezgpvuhl0lyEMFTuKm
        +J2D5KwjzgNLMEMG6dumKb7Zjohy8dxvhHqqH9USQrF570ug+i5pLHcZB66Z0bBC
        -----END PUBLIC KEY-----
    defaultLocalConfig:
    - file: fermi.local.repo.conf
        content: |
        CVMFS_SERVER_URL=http://<CHANGEME>/cvmfs/fermi.local.repo
        CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/fermi.local.repo.pub
        CVMFS_HTTP_PROXY=DIRECT
```


TODO: put link