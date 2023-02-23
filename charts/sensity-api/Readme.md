# Sensity API Helm Chart

Sensity is a suite of customizable verification tools including liveness
detection and face matching, ID documents verification, financial documents
anti-fraud, deepfake detection, and more. These tools can be combined to score
the trust of a user's identity and the authenticity of their image, video and
PDF files.


## Get the Repository

``` sh
helm repo add sensity-ai https://sensity-ai.github.io/helm-charts
helm repo update
```

## Prerequisites

- Helm 3

- Image pull secret deployed in your cluster to connect Sensity Container
  registry. Create one with the `key.json` file provided by Sensity.

``` sh
kubectl create secret docker-registry sensity-registry creds \
  --docker-server=https://europe-west4-docker.pkg.dev \
  --docker-username=_json_key_base64 \
  --docker-password="$(cat /path/to/key.json | base64)" \
  --docker-email=oci-oke@sensity-350013.iam.gserviceaccount.com
```

- Minimum memory resources per product:

  - GAN Detection: 2GB
  
  - ID Document Reader: 8GB
  
  - Inference: 8GB

## Installing the Chart

Install the chart with the release name `sensity-api`:

``` sh
helm upgrade --install sensity-api sensity-ai/sensity-api
```

## Uninstalling the Chart

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

The following table shows a brief description for the configuration of Sensity
API and the common values available between products. You will find a more
extended description of every field in the `values.yaml` of each subchart.

Note this configuration is per-product, so you will have to prepend the product
name before. For example, if you want to configure the `replicaCount` of the
`gan-detection` sub-chart, you will have to refer to the value as
`gan-detection.replicaCount`.

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

## Example: using nginx ingress controller as a reverse proxy

This example shows how to install this chart with ingress enabled along with
nginx ingress controller.

1. Install [NGINX Ingress
   Controller](https://kubernetes.github.io/ingress-nginx/deploy/) in your
   cluster.

2. Install the chart and enable ingress in the services you want to deploy
   behind the proxy configuring them to use the previously installed nginx
   ingress controller.
   
``` sh
# enable ingress for gan-detection
helm upgrade --install sensity-api sensity-ai/sensity-api \
  --set gan-detection.ingress.enabled=true \
  --set gan-detection.ingress.className=nginx \
  --set gan-detection.ingress.annotations."nginx\.ingress\.kubernetes\.io/rewrite-target"='$2' \
  --set gan-detection.config.apiRootPath=/gan-detection
```

In the previous command we enable ingress for gan-detection. The other services
also need to be enabled if you want to set the ingress rules.

3. Once the chart is installed in your cluster, access through your nginx
   controller to `https://your-nginx-controller-address.com/gan-detection/docs`.
   You should be able to see the Swagger UI of the web service.
