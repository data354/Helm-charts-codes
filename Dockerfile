FROM openjdk:8-slim
LABEL maintainer="team354"
LABEL hive-metastore-version="3.0.0"
#Ce paramètre empêche le masquage des erreurs dans un pipeline
    SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG HADOOP_VERSION=3.2.0

RUN apt-get update && \
    apt-get install -y curl --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Hadoop/HiveMetastore variables and Classpath
ENV HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"
ENV METASTORE_HOME="/opt/apache-hive-metastore-3.0.0-bin"
ENV HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*:${METASTORE_HOME}/lib"
ENV PATH="${HADOOP_HOME}/bin:${METASTORE_HOME}/lib/:${HADOOP_HOME}/share/hadoop/tools/lib/:/opt/postgresql-jdbc.jar:${PATH}"
ENV HIVE_CONF_DIR="${METASTORE_HOME}/conf"


# Download and extract the Hadoop binary package.
RUN curl -O https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz  

RUN tar xvzf hadoop-$HADOOP_VERSION.tar.gz -C /opt/     
# Add S3a jars to the classpath using this hack.
RUN ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-aws* /opt/hadoop/share/hadoop/common/lib/ && \
    ln -s /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk* /opt/hadoop/share/hadoop/common/lib/