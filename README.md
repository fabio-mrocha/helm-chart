# Helm Charts repository for Kubernetes

This repository contains Helm Charts for testing purposes.

| Charts                                                                                                     | Description                                                        |
|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| [app-chart](https://github.com/fabio-mrocha/helm-chart/tree/main/charts/app-chart)                         | Application Deployment Helm Chart.                                 |
| [gateway-api](https://github.com/fabio-mrocha/helm-chart/tree/main/charts/gateway-api)                     | Gateway API Deployment Helm Chart.                                 | 

## Adding the MongoDB Helm Repo

The MongoDB Helm repository can be added using the `helm repo add` command, like
in the following example:

```
$ helm repo add mongodb https://fabio-mrocha.github.io/helm-chart
"mongodb" has been added to your repositories
```