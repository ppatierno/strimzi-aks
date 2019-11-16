# Kafka resource

An Apache Kafka cluster is described by a `Kafka` custom resource with the declaration of Kafka brokers (replicas, configuration, listeners, storage, ...), ZooKeeper nodes, users and topics operators.

To deploy a Kafka cluster using the provided `Kafka` resource, just run:

```shell
kubectl apply -f 03-deploy-kafka/
```

The Cluster Operator takes care of this resource and starts to deploy all the stuff needed for having the Kafka cluster up and running.
At the end of the process you can check the deployed pods (you can also follow the process in real time using the `-w` option).

```shell
kubectl get pods -n default

NAME                                          READY   STATUS    RESTARTS   AGE
my-cluster-entity-operator-7494f55b87-8k824   3/3     Running   0          27s
my-cluster-kafka-0                            2/2     Running   0          89s
my-cluster-kafka-1                            2/2     Running   0          88s
my-cluster-kafka-2                            2/2     Running   0          88s
my-cluster-zookeeper-0                        2/2     Running   0          4m33s
my-cluster-zookeeper-1                        2/2     Running   0          4m33s
my-cluster-zookeeper-2                        2/2     Running   0          4m33s
```

It is possible to check the PVC (Persistent Volume Claims) created for the related persistent storage.

```shell
kubectl get pvc

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
kubectl get service

NAME                                  TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
kubernetes                            ClusterIP      10.0.0.1       <none>           443/TCP                      77m
my-cluster-kafka-0                    LoadBalancer   10.0.39.16     52.142.86.213    9094:31766/TCP               9m49s
my-cluster-kafka-1                    LoadBalancer   10.0.143.231   52.156.196.116   9094:32400/TCP               9m49s
my-cluster-kafka-2                    LoadBalancer   10.0.253.89    52.155.235.46    9094:30692/TCP               9m49s
my-cluster-kafka-bootstrap            ClusterIP      10.0.17.179    <none>           9091/TCP,9092/TCP,9093/TCP   9m50s
my-cluster-kafka-brokers              ClusterIP      None           <none>           9091/TCP,9092/TCP,9093/TCP   9m50s
my-cluster-kafka-external-bootstrap   LoadBalancer   10.0.125.10    52.155.233.252   9094:31666/TCP               9m49s
my-cluster-zookeeper-client           ClusterIP      10.0.224.219   <none>           2181/TCP                     11m
my-cluster-zookeeper-nodes            ClusterIP      None           <none>           2181/TCP,2888/TCP,3888/TCP   11m
```

Each Kafka broker has an external address provided via a LoadBalancer.
There is also a "bootstrap" service used for the first connection from clients.

The Kafka cluster is now available as a Kubernetes native resource.

```shell
kubectl get kafka

NAME         DESIRED KAFKA REPLICAS   DESIRED ZK REPLICAS
my-cluster   3                        3
```

Finally, to delete the cluster, just delete the corresponding custom resource.

```shell
kubectl delete kafka my-cluster
```