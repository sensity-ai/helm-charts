# Sensity API Helm Chart
---

Sensity is a suite of customizable verification tools including liveness
detection and face matching, ID documents verification, financial documents
anti-fraud, deepfake detection, and more. These tools can be combined to score
the trust of a user's identity and the authenticity of their image, video and
PDF files.


## Get Repository
---

**TODO**: Setup the repository in GH Pages

## Prerequisites
---

**TODO**: Describe RAM requested by pod. Find it in GCLoud cluster

- Helm 3

## Installing the Chart
---

Install the chart with the release name `sensity-api`:

**TODO**: write the final command pointing to the repository

``` sh
helm upgrade --install sensity-api repo/name
```

## Uninstalling the Chart
---

To uninstall the `sensity-api` chart from your cluster:

``` sh
helm delete sensity-api
```

This removes all the Kubernetes components associated with the chart and release
the release from the cluster.

## Chart components

The `sensity-api` chart is composed by several sub-charts. Each of them is one
of the products provided by Sensity. You can enable/disable what products you
want to deploy in your cluster based on your needs.

To enable a product with name `product` on your release. Set the `enabled` value
to `true`:

``` sh
helm upgrade --install sensity-api repo/name --set product.enabled=true
```

## Values
---

The following table shows a brief description for the configuration of Sensity
API and the common values available between products. You will find a more
extended description of every field in the `values.yaml` of each subchart.

Moreover, note this configuration is per-product, so you will have to prepend
the product name before. For example, if you want to configure the
`replicaCount` of the `gan-detection` sub-chart, you will have to refer to the
value as `gan-detection.replicaCount`.

| **Value**             | **Description**                                          | **Default**                                                                       |
|:----------------------|:---------------------------------------------------------|:----------------------------------------------------------------------------------|
| `replicaCount`        | Number of replicas                                       | `1`                                                                               |
| `image.repository`    | Image repository whose default is our container registry |                                                                                   |
| `image.tag`           | Tag of image whose default is the `AppVersion`           |                                                                                   |
| `image.pullPolicy`    | Kuberentes Image pull policy                             | `IfNotPresent`                                                                    |
| `imagePullSecrets`    | Secrets used to log in Sensity container registry        | `[]`                                                                              |
| `licenseKey`          | License key provided by Sensity                          | `""`                                                                              |
| `service.type`        | Kubernetes service type                                  | `ClusterIP`                                                                       |
| `service.port`        | Port used by the service                                 | `80`                                                                              |
| `config.apiRootPath`  | Path used to serve the application behind a proxy        | `""`                                                                              |
| `ingress.enabled`     | Enable ingress                                           | `false`                                                                           |
| `ingress.className`   | Class name of the ingress controller                     | `""`                                                                              |
| `ingress.annotations` | Ingress annotations                                      | `{}`                                                                              |
| `ingress.hosts`       | Rules of the ingress                                     | `[{"host": "", "paths": [{"path": "/product(/\|$)(.*)", "pathType": "Prefix"}]}]` |
| `ingress.tls`         | TLS termination for the web ingress                      | `[]`                                                                              |
| `resources`           | CPU/Memory resource requests/limits                      | `{}`                                                                              |
