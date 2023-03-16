FROM debian:stretch-slim

# System requirements: https://docs.confluent.io/platform/current/installation/system-requirements.html#software
# Manual: https://docs.confluent.io/platform/current/installation/installing_cp/deb-ubuntu.html
# Zulu OpenJDK: https://docs.azul.com/core/zulu-openjdk/install/debian

# apt-get may require non boolean input (like installing tzdata requires select zone)
ENV DEBIAN_FRONTEND=noninteractive

ARG ZULU_OPENJDK_VERSION=11

COPY schema-registry.properties.tpl /etc/schema-registry/schema-registry.properties.tpl
COPY log4j.properties.tpl /etc/schema-registry/log4j.properties.tpl

RUN \
    echo "###### Install deps" && \
    apt-get update && \
    apt-get install -y wget gnupg apt-utils software-properties-common apt-transport-https gettext-base kafkacat && \
    echo "###### Add support of Zulu OpenJDK" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 && \
    echo "deb [arch=amd64,arm64] https://repos.azul.com/zulu/deb/ stable main" > /etc/apt/sources.list.d/zulu-openjdk.list && \
    echo "###### Add support on confluent packages" && \
    wget -qO - https://packages.confluent.io/deb/7.0/archive.key | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/7.0 stable main" && \
    add-apt-repository "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main" && \
    echo "###### Update packages from new sources" && \
    echo "###### Install Zulu OpenJDK" && \
    apt-get update && \
    apt-get -y install zulu${ZULU_OPENJDK_VERSION}-jre-headless && \
    echo "###### Install Confluent Schema Registry" && \
    apt-get update && \
    apt-get install -y confluent-schema-registry && \
    echo "###### Remove unused deps" && \
    apt-get purge -y wget gnupg apt-utils software-properties-common apt-transport-https && \
    apt-get autoremove -y

EXPOSE 8081

COPY schema-registry-entrypoint.sh /schema-registry-entrypoint.sh
RUN chmod +x /schema-registry-entrypoint.sh

CMD ["/schema-registry-entrypoint.sh"]

