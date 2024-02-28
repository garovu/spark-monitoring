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

//update soon

## Reference

* [Spark 3.0 Monitoring with Prometheus](https://dzlab.github.io/bigdata/2020/07/03/spark3-monitoring-1/)
