# Deploy Strimzi

## OperatorHub.io

The [OperatorHub.io](https://operatorhub.io/) website provides a bunch of operators for Kubernetes.

## Install OLM (Operator Lifecycle Manager)

In order to install an operator in the Kubernetes cluster, the OLM (Operator Lifecycle Manager) is needed.
It's a tool to help manage the operators running on your cluster.

```shell
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.13.0/install.sh | bash -s 0.13.0
```

The OLM component together with the operators catalog will run in the new `olm` namespace.

```shell
kubectl get pods -n olm

NAME                                READY   STATUS    RESTARTS   AGE
catalog-operator-7c765f678d-sc9js   1/1     Running   0          2m37s
olm-operator-5fd5c7dd97-s7qzw       1/1     Running   0          2m37s
operatorhubio-catalog-h4vmt         1/1     Running   0          2m25s
packageserver-58d86869bf-4tpp4      1/1     Running   0          2m22s
packageserver-58d86869bf-8hhpf      1/1     Running   0          2m12s
```

## Install the Strimzi operator

Install the operator by running the following command.

```shell
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
```

Follow the installation process of the latest Strimzi operator version (0.14.0).

```shell
kubectl get csv -n operators -w

NAME                               DISPLAY                         VERSION   REPLACES                           PHASE
strimzi-cluster-operator.v0.14.0   Strimzi Apache Kafka Operator   0.14.0    strimzi-cluster-operator.v0.13.0   Installing
strimzi-cluster-operator.v0.14.0   Strimzi Apache Kafka Operator   0.14.0    strimzi-cluster-operator.v0.13.0   Succeeded
```

Finally, the related pod is running in the `operators` namespace.

```shell
kubectl get pods -n operators

NAME                                                READY   STATUS    RESTARTS   AGE
strimzi-cluster-operator-v0.14.0-698459d6c5-sm4vr   1/1     Running   0          109s
```

The operator brings all the CRDs (Custom Resource Definitions) which it's able to handle like `Kafka`, `KafkaConnect`, `KafkaMirrorMaker`, `KafkaBridge`, `KafkaTopic` and `KafkaUser`. It will watch for the related custom resource creation in all the namespace on the Kubernetes cluster.