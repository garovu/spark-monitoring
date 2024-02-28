#!/bin/bash

SPARK_WORKLOAD=$1

echo "SPARK_WORKLOAD: $SPARK_WORKLOAD"

start-master.sh -p 7077

bin/spark-shell --conf "spark.driver.extraJavaOptions=-javaagent:jars/jmx_prometheus_javaagent-0.20.0.jar=12345:conf/jmx_config.yml