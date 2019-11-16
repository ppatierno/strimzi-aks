# Prerequisites

After deploying AKS, the first resources to install are Prometheus and Grafana in order to have the stuff for gathering metrics from the Apache Kafka cluster and related applications.

```shell
kubectl apply -f 01-prerequisites
```

Check that Grafana and Prometheus pods are now running.

```shell
kubectl get pods -n strimzi-demo

NAME                                          READY   STATUS    RESTARTS   AGE
grafana-6547c6f94-5xc5l                       1/1     Running   0          8m21s
prometheus-849c765cfc-wdwc9                   1/1     Running   0          8m23s
```

In order to access the Grafana dashboard, we have to get the address of the exposed service

```shell
kubectl get service -n strimzi-demo

NAME                                  TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                               AGE
grafana                               LoadBalancer   10.0.128.110   52.155.88.253    80:30336/TCP                          9m43s
prometheus                            LoadBalancer   10.0.78.71     52.155.89.120    9090:32414/TCP                        9m45s
```