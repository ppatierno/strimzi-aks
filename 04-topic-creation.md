## Topic creation

# KafkaTopic resource

In order to create a topic through the Topic Operator, the provided `KafkaTopic` custom resource can be deployed.

```shell
kubectl apply -f 04-topic-creation
```

A Kafka topic is now available as a Kubernetes native resource.

```shell
kubectl get kafkatopic -n strimzi-demo

NAME       PARTITIONS   REPLICATION FACTOR
my-topic   3            3
```

You can check the topic was created by the Topic Operator in the Kafka cluster by running.

```shell
kubectl exec -it my-cluster-kafka-0 -c kafka -n strimzi-demo -- bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --list

OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
my-topic
```

If you want to get more information like the number of partitions, the leaders and so on.

```shell
kubectl exec -it my-cluster-kafka-0 -c kafka -n strimzi-demo -- bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --describe --topic my-topic

OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
Topic:my-topic  PartitionCount:3        ReplicationFactor:3     Configs:segment.bytes=104857600,retention.ms=7200000,message.format.version=2.3-IV1,retention.bytes=1073741824
        Topic: my-topic Partition: 0    Leader: 2       Replicas: 2,0,1 Isr: 2,0,1
        Topic: my-topic Partition: 1    Leader: 0       Replicas: 0,1,2 Isr: 0,1,2
        Topic: my-topic Partition: 2    Leader: 1       Replicas: 1,2,0 Isr: 1,2,0
```