# KafkaTopic resource

In order to create a topic through the Topic Operator.

```shell
kubectl apply -f 04-topic
```

You can check the topic was created by the Topic Operator in the Kafka cluster by running.

```shell
kubectl exec -it my-cluster-kafka-0 -c kafka -n strimzi-demo -- bin/kafka-topics.sh -bootstrap-server my-cluster-kafka-bootstrap:9092 --list

OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
my-topic
```