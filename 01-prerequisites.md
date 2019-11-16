# Prerequisites

After deploying AKS, the first resources to install are Prometheus and Grafana in order to have the stuff for gathering metrics from the Apache Kafka cluster and related applications.

```shell
kubectl apply -f 01-prerequisites/
```