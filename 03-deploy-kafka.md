# Deploy Apache Kafka

## Kafka resource

An Apache Kafka cluster is described by a `Kafka` custom resource with the declaration of Kafka brokers (replicas, configuration, listeners, storage, ...), ZooKeeper nodes, users and topics operators.

To deploy a Kafka cluster using the provided `Kafka` resource, just run:

```shell
kubectl apply -f 03-deploy-kafka
```

The Cluster Operator takes care of this resource and starts to deploy all the stuff needed for having the Kafka cluster up and running.
At the end of the process you can check the deployed pods (you can also follow the process in real time using the `-w` option).

```shell
kubectl get pods -n strimzi-demo

NAME                                          READY   STATUS    RESTARTS   AGE
grafana-6547c6f94-5xc5l                       1/1     Running   0          10m
my-cluster-entity-operator-54bf8f465b-tht2n   3/3     Running   0          3m23s
my-cluster-kafka-0                            2/2     Running   0          4m27s
my-cluster-kafka-1                            2/2     Running   0          4m27s
my-cluster-kafka-2                            2/2     Running   0          4m27s
my-cluster-kafka-exporter-875cb56df-6zr2t     1/1     Running   0          3m3s
my-cluster-zookeeper-0                        2/2     Running   0          7m21s
my-cluster-zookeeper-1                        2/2     Running   0          7m21s
my-cluster-zookeeper-2                        2/2     Running   0          7m21s
prometheus-849c765cfc-wdwc9                   1/1     Running   0          10m
```

It is possible to check the PVC (Persistent Volume Claims) created for the related persistent storage.

```shell
kubectl get pvc -n strimzi-demo

NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-0-my-cluster-kafka-0     Bound    pvc-361d0eb8-0885-44ef-971e-41c2fadea007   100Gi      RWO            default        7m55s
data-0-my-cluster-kafka-1     Bound    pvc-715d9e67-f595-4acb-89df-546636d4a342   100Gi      RWO            default        7m55s
data-0-my-cluster-kafka-2     Bound    pvc-665b0b49-65e4-4d74-9d98-8f3f5f8bb49b   100Gi      RWO            default        7m55s
data-my-cluster-zookeeper-0   Bound    pvc-4841db24-b9ee-40b1-8dcb-ca58bcd2043f   100Gi      RWO            default        9m38s
data-my-cluster-zookeeper-1   Bound    pvc-806721ee-9a31-4de1-9d93-186fef515ddd   100Gi      RWO            default        9m38s
data-my-cluster-zookeeper-2   Bound    pvc-6e6a7bac-9eec-4f8d-86e1-a5402c7952a0   100Gi      RWO            default        9m38s
```

They are bound to Azure Disks that are deployed for you in the same resource group.

> For check the Azure Disks use the `az disk list` command

Finally, in order to access the Kafka brokers from outside the Kubernetes cluster, thanks to the external listener declaration using LoadBalancer, the following services are created by the operator.

```shell
kubectl get service -n strimzi-demo

NAME                                  TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                               AGE
grafana                               LoadBalancer   10.0.128.110   52.155.88.253    80:30336/TCP                          9m43s
my-cluster-kafka-0                    LoadBalancer   10.0.75.134    52.155.237.252   9094:32276/TCP                        4m42s
my-cluster-kafka-1                    LoadBalancer   10.0.160.65    52.155.236.155   9094:31355/TCP                        4m42s
my-cluster-kafka-2                    LoadBalancer   10.0.183.136   52.158.124.239   9094:30768/TCP                        4m42s
my-cluster-kafka-bootstrap            ClusterIP      10.0.70.125    <none>           9091/TCP,9092/TCP,9093/TCP,9404/TCP   4m42s
my-cluster-kafka-brokers              ClusterIP      None           <none>           9091/TCP,9092/TCP,9093/TCP            4m42s
my-cluster-kafka-exporter             ClusterIP      10.0.174.167   <none>           9404/TCP                              2m13s
my-cluster-kafka-external-bootstrap   LoadBalancer   10.0.75.194    52.155.93.2      9094:30566/TCP                        4m42s
my-cluster-zookeeper-client           ClusterIP      10.0.94.120    <none>           9404/TCP,2181/TCP                     6m31s
my-cluster-zookeeper-nodes            ClusterIP      None           <none>           2181/TCP,2888/TCP,3888/TCP            6m31s
prometheus                            LoadBalancer   10.0.78.71     52.155.89.120    9090:32414/TCP                        9m45s
```

Each Kafka broker has an external address provided via a LoadBalancer.
There is also a "bootstrap" service used for the first connection from clients.

The Kafka cluster is now available as a Kubernetes native resource.

```shell
kubectl get kafka -n strimzi-demo

NAME         DESIRED KAFKA REPLICAS   DESIRED ZK REPLICAS
my-cluster   3                        3
```

Finally, to delete the cluster, just delete the corresponding custom resource.

```shell
kubectl delete kafka my-cluster -n strimzi-demo
```