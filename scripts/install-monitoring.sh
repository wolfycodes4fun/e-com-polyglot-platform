#!/bin/bash

# Description: This script install the monitoring stack (Prometheus, Grafana & Alertmanager)
# responsible for the monitoring aspect of the e-com-polyglot-platform. Only run this script
# once your cluster is up and running and kube config is set. You'll only run this if the
# monitoring stack is not already installed in your cluster.