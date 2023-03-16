#!/bin/bash

if [[ -z $SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS ]]; then
  echo "Bootstrap servers not specified"
  exit 1
fi

# Update configuration
envsubst '$SCHEMA_REGISTRY_HOST_NAME $SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS $SCHEMA_REGISTRY_LISTENERS' \
      < /etc/schema-registry/schema-registry.properties.tpl > /etc/schema-registry/schema-registry.properties

envsubst '$SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL' \
      < /etc/schema-registry/log4j.properties.tpl > /etc/schema-registry/log4j.properties

# Wait for brokers
echo "Waining for brokers ${SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS} readiness..."
is_kafka_ready=0
for ((i=1; i<=${SCHEMA_REGISTRY_WAIT_FOR_SERVICES_TRIES:-30}; i++)); do
  trap 'exit 1;' SIGINT SIGTERM
  kafkacat -L -b $SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS 2>/dev/null >/dev/null
  if [[ $? != 0 ]]; then
    echo -n "."
    sleep 1
  else
    is_kafka_ready=1
    break
  fi
done
echo ""

# Exit on error
if [[ is_kafka_ready -eq 0 ]]; then
  echo "Can not connect to kafka brokers. Shutdown..."
  exit 1
else
  echo "Kafka brokers ready!"
fi

# run schema registry
schema-registry-start /etc/schema-registry/schema-registry.properties
