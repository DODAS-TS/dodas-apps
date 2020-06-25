# Mount a PersistenVolume on worker nodes

## Requirements

To share volumes through K8s PersitentVolumes on the worker node you should apply simple changes to the HTCondor HELM values indicated either for DODAS ([this guide](condor.md)) or plain HELM ([this other guide](condor-helm.md)).

## Configuration

### NFS

To use the K8s NFS PersitentVolume module you can mount on WNs spaces trhough NFS adding the persistentVolume section to the HELM values file:

```yaml
htcWn:
    persistentVolume:
        pv:
            name: "data-nfs-1"
            spec: |
                accessModes:
                - ReadWriteMany
                capacity:
                    storage: 800Gi
                mountOptions:
                    - hard
                    - nfsvers=4.1
                nfs:
                    path: /tmp
                    server: 172.17.0.2
                storageClassName: nfs
        pvc:
            name: "data-nfs-1"
            mountPath: "/home/Volume_Fermi"
            spec: |
                accessModes:
                - ReadWriteMany
                resources:
                    requests:
                    storage: "799Gi"
                volumeName: data-nfs-1
                selector:
                    matchLabels:
                    name: data-nfs-1
```

### RClone

To use the rclone CSI module you can mount on WNs spaces mounted by [RClone](https://rclone.org/) adding the persistentVolume section to the HELM values file:

```yaml
htcWn:
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
```