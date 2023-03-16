# Confluent Schema Registry 

Slim Docker image of Confluent Schema Registry, based on debian:stretch-slim and uses headless Zulu OpenJDK.

Usage in docker-compose:

```yaml
schema-registry:
    image: confluent-schema-registry-slim:latest
    variables:
        SCHEMA_REGISTRY_HOST_NAME: schema-registry
        SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS: broker:9092
        SCHEMA_REGISTRY_LISTENERS: http://0.0.0.0:8081
        SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL: INFO
        SCHEMA_REGISTRY_WAIT_FOR_SERVICES_TRIES: 30
```
