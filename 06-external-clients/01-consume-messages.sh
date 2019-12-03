#!/usr/bin/env bash
HOSTNAME=$(kubectl get service my-cluster-kafka-external-bootstrap -n strimzi-demo -o=jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}')
PORT=9094
06-external-clients/bin/kafka-console-consumer.sh --bootstrap-server ${HOSTNAME}:${PORT} --topic my-topic-2 --group my-group