# rhoai-environment-chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

Deploy complete Red Hat OpenShift AI Data Science environments with workbenches, pipelines, and distributed workloads support

**Homepage:** <https://github.com/yourusername/rhoai-environment-chart>

## Overview

This Helm chart deploys a complete Red Hat OpenShift AI (RHOAI) Data Science environment, including:

- **Data Science Project** (namespace and configuration)
- **Data Science Pipelines (DSPA)** with configurable storage backends (MinIO, ODF, AWS S3)
- **Workbenches** (Jupyter-compatible notebook environments)
- **Distributed Workloads** support for multi-node training
- **Kueue Integration** for job queueing and resource management
- **Model Tuning** capabilities (optional)

## Prerequisites

- Red Hat OpenShift AI operator installed
- Kubernetes/OpenShift cluster with RHOAI configured
- Helm 3.x installed
- Storage provider configured (MinIO, ODF, or AWS S3) if using pipelines

## Installation

### Basic Installation

```bash
helm install my-rhoai-env . -n <namespace>
```

### Installation with Custom Values

```bash
helm install my-rhoai-env . -n <namespace> -f custom-values.yaml
```

### Upgrade

```bash
helm upgrade my-rhoai-env . -n <namespace>
```

## Configuration Examples

### Example 1: Basic Setup with MinIO

```yaml
dataScienceProjectDisplayName: My ML Project
dataScienceProjectNamespace: ml-workspace

pipelines:
  storageBackend: minio
  awsS3Endpoint: minio.minio.svc.cluster.local
  awsS3Port: "9000"

workbenches:
  - name: pytorch-notebook
    displayName: PyTorch Workbench
    image: pytorch:2025.2
    storage: 10Gi
```

### Example 2: GPU-Enabled Workbench

```yaml
workbenches:
  - name: gpu-notebook
    displayName: GPU Notebook
    image: pytorch:2025.2
    hardwareProfile:
      name: gpu-profile
      namespace: redhat-ods-applications
    storage: 20Gi
    resources:
      limits:
        cpu: '4'
        memory: 16Gi
        nvidiaGpu: '1'
      requests:
        cpu: '2'
        memory: 8Gi
        nvidiaGpu: '1'
```

### Example 3: OpenShift Data Foundation (ODF)

```yaml
pipelines:
  storageBackend: odf
  secretName: dspa-pipelines-connection-secret
  type: s3
  scheme: https
  awsS3Endpoint: s3.openshift-storage.svc
  awsS3Port: "443"
```

### Example 4: AWS S3 Backend

```yaml
pipelines:
  storageBackend: aws
  secretName: dspa-pipelines-connection-secret
  type: s3
  scheme: https
  awsAccessKeyId: YOUR_ACCESS_KEY_ID
  awsSecretAccessKey: YOUR_SECRET_ACCESS_KEY
  awsDefaultRegion: eu-west-1
  awsS3Endpoint: s3.eu-west-1.amazonaws.com
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Alvaro Lopez Medina | <your.email@example.com> |  |

## Source Code

* <https://github.com/yourusername/rhoai-environment-chart>

## Values

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dataScienceProjectDisplayName | string | `"RHOAI - Playground"` | Display name for the Data Science Project |
| dataScienceProjectNamespace | string | `"rhoai-playground"` | Namespace where the Data Science Project will be created |
| distributedWorkloads | object | `{"enabled":true}` | Distributed workloads configuration for running training jobs across multiple nodes |
| distributedWorkloads.enabled | bool | `true` | Enable or disable distributed workloads support |
| kueue | object | `{"clusterQueueName":"cluster-queue","localQueueName":"default"}` | Kueue configuration for job queueing and resource management **Important:** Queue names must match those defined in rhoai-installation-chart |
| kueue.clusterQueueName | string | `"cluster-queue"` | Name of the cluster-wide queue |
| kueue.localQueueName | string | `"default"` | Name of the local queue within the namespace |
| modelTunning | object | `{"enabled":false}` | Model tuning/fine-tuning configuration |
| modelTunning.enabled | bool | `false` | Enable or disable model tuning capabilities |
| pipelines | object | See values below | Data Science Pipelines (DSPA) configuration. Omit this entire section to skip DSPA and pipeline storage setup. |
| pipelines.awsS3Endpoint | string | `"minio.minio.svc.cluster.local"` | S3-compatible endpoint URL |
| pipelines.awsS3Port | string | `"9000"` | S3-compatible endpoint port |
| pipelines.scheme | string | `"http"` | Connection scheme. Options: `http`, `https` |
| pipelines.secretName | string | `"dspa-pipelines-connection-secret"` | Name of the secret containing pipeline connection credentials |
| pipelines.storageBackend | string | `"minio"` | Storage backend type for pipelines. Options: `minio`, `odf`, `aws` |
| pipelines.type | string | `"s3"` | Storage type (currently only s3-compatible is supported) |
| workbenches | list | See example values below | List of workbench configurations to deploy. Each workbench creates a Jupyter-compatible notebook environment. |
| workbenches[0] | object | `{"description":"This is an example Workbench using the PyTorch Image","displayName":"Notebook","hardwareProfile":{"name":"cpu-profile","namespace":"redhat-ods-applications"},"image":"pytorch:2025.2","name":"notebook","resources":{"limits":{"cpu":"3","memory":"10Gi"},"requests":{"cpu":"1","memory":"6Gi"}},"storage":"5Gi"}` | Unique name for the workbench (used in resource names) |
| workbenches[0].description | string | `"This is an example Workbench using the PyTorch Image"` | Description of the workbench shown in the UI |
| workbenches[0].displayName | string | `"Notebook"` | Display name shown in the RHOAI UI |
| workbenches[0].hardwareProfile | object | `{"name":"cpu-profile","namespace":"redhat-ods-applications"}` | Hardware profile configuration |
| workbenches[0].hardwareProfile.name | string | `"cpu-profile"` | Name of the hardware profile to use |
| workbenches[0].hardwareProfile.namespace | string | `"redhat-ods-applications"` | Namespace where the hardware profile is defined |
| workbenches[0].image | string | `"pytorch:2025.2"` | Container image to use for the workbench (e.g., pytorch:2025.2, tensorflow:latest) |
| workbenches[0].resources | object | `{"limits":{"cpu":"3","memory":"10Gi"},"requests":{"cpu":"1","memory":"6Gi"}}` | Resource limits and requests for the workbench pod |
| workbenches[0].resources.limits | object | `{"cpu":"3","memory":"10Gi"}` | Resource limits |
| workbenches[0].resources.limits.cpu | string | `"3"` | CPU limit |
| workbenches[0].resources.limits.memory | string | `"10Gi"` | Memory limit |
| workbenches[0].resources.requests | object | `{"cpu":"1","memory":"6Gi"}` | Resource requests |
| workbenches[0].resources.requests.cpu | string | `"1"` | CPU request |
| workbenches[0].resources.requests.memory | string | `"6Gi"` | Memory request |
| workbenches[0].storage | string | `"5Gi"` | Storage size for the workbench persistent volume |

## Storage Backend Options

This chart supports multiple storage backends for Data Science Pipelines:

| Backend | Use Case | Configuration |
|---------|----------|---------------|
| **MinIO** | Development/Testing | Internal cluster MinIO deployment |
| **ODF** | Production on OpenShift | OpenShift Data Foundation S3 |
| **AWS S3** | Cloud deployments | Amazon S3 service |

## Distributed Workloads

When `distributedWorkloads.enabled: true`, ensure your cluster has:
- Kueue operator installed
- Matching cluster queue configured
- Appropriate resource quotas set

## Notes

- The `dataScienceProjectNamespace` value determines where all resources are created
- Workbenches can be configured with different hardware profiles (CPU/GPU)
- Multiple workbenches can be defined in a single deployment
- To skip pipeline installation, omit the entire `pipelines` section from your values
- Queue names in `kueue` section must match your cluster-wide Kueue configuration

## Troubleshooting

### Workbench not starting
- Check hardware profile exists: `oc get hardwareprofile -n redhat-ods-applications`
- Verify resource quotas in the namespace
- Check workbench logs: `oc logs <workbench-pod> -n <namespace>`

### Pipeline connection issues
- Verify storage backend is accessible
- Check secret contains correct credentials: `oc get secret <secretName> -n <namespace> -o yaml`
- Validate S3 endpoint is reachable from the cluster

https://github.com/yourusername/rhoai-environment-chart

---
*Generated using [helm-docs](https://github.com/norwoodj/helm-docs)*
