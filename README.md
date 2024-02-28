# Overview

This project focus to set-up promethues-native monitoring for spark metrics.

## Monitoring in Spark >3.0 using PrometheusServlet

Apache Spark 3.0 introduced the following resources to expose metrics:

* `PrometheusServlet` [SPARK-29032](https://issues.apache.org/jira/browse/SPARK-29032) which makes the Master/Worker/Driver nodes expose metrics in a Prometheus format (in addition to JSON) at the existing ports, i.e. 8080/8081/4040.

* `PrometheusResource` [SPARK-29064](https://issues.apache.org/jira/browse/SPARK-29064)/[SPARK-29400](https://issues.apache.org/jira/browse/SPARK-29400) which export metrics of all executors at the driver. Enabled by `spark.ui.prometheus.enabled` (default: `false`)

Those features are more convinent than the agent approach that requires a port to be open (which may not be possible). The following tables summaries the new exposed endpoints for each node:

||Port| Prometheus Endpoint | JSON Endpoint |
|--|--|--|--|
|Driver| 4040| /metrics/prometheus/| /metrics/json/|
|Driver| 4040| /metrics/executors/prometheus/| /api/v1/applications/{id}/executors/|
|Worker| 8081| /metrics/prometheus/| /metrics/json/|
|Master| 8080| /metrics/master/prometheus/| /metrics/master/json/|
|Master| 8080| /metrics/applications/prometheus/| /metrics/applications/json/|

Copy `$SPARK_HOME/conf/metrics.properties.template` into `$SPARK_HOME/conf/metrics.properties` and add/uncomment the following lines (they should at the end of the template file):
```
*.sink.prometheusServlet.class=org.apache.spark.metrics.sink.PrometheusServlet
*.sink.prometheusServlet.path=/metrics/prometheus
master.sink.prometheusServlet.path=/metrics/master/prometheus
applications.sink.prometheusServlet.path=/metrics/applications/prometheus
```

## Monitoring in Spark using JMXSink

![](https://dzlab.github.io/assets/2020/20200608-spark-monitoring.png)

Create new a application using `spark-shell` and add java-agent(jmx-exporter) to it (client mode).

```shell
bin/spark-shell \
    --master spark://spark:7077 \
    --conf "spark.driver.extraJavaOptions=-javaagent:jars/jmx_prometheus_javaagent-0.20.0.jar=9393:conf/jmx_config.yml"
```

Or sending a application using `spark-submit`.

```shell
./spark-submit \
  ... \
  --conf spark.driver.extraJavaOptions=-javaagent:$SPARK_HOME/jars/jmx_prometheus_javaagent.jar=9091:$SPARK_HOME/conf/prometheus-config.yml \
  ...

```

### spark.driver.extraJavaOptions

>A string of extra JVM options to pass to the driver. This is intended to be set by users. For instance, GC settings or other logging. Note that it is illegal to set maximum heap size (-Xmx) settings with this option. Maximum heap size settings can be set with spark.driver.memory in the cluster mode and through the --driver-memory command line option in the client mode.
Note: In client mode, this config must not be set through the SparkConf directly in your application, because the driver JVM has already started at that point. Instead, please set this through the --driver-java-options command line option or in your default properties file. spark.driver.defaultJavaOptions will be prepended to this configuration.

## Reference

* [Spark 3.0 Monitoring with Prometheus](https://dzlab.github.io/bigdata/2020/07/03/spark3-monitoring-1/)
