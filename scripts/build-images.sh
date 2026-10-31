#!/bin/bash
# Description: This script clones the e-com-polglot repo and builds the Docker images 
# for each of the defined services. It then makes those images available to be used by your
# kind or minikube cluster. Intended to run just once during setup

set -euo pipefail

# Path to clone the e-com-polyglot repo
ecom_polyglot_repo=$1
local_cluster_type=$2
local_cluster_name=$3
POSTGRES_IMAGE_TAG="${4:-17-alpine}"


mkdir -p $ecom_polyglot_repo && cd $ecom_polyglot_repo \
&& git clone git@github.com:wolfycodes4fun/e-com-polyglot.git \
&& cd e-com-polyglot

docker_images=(
    "analytics-service:v2"
    "auth-service:v2"
    "catalog-service:v2"
    "inventory-service:v2"
    "notification-service:v2"
    "order-service:v2"
    "payment-service:v2"
)

if [[ $local_cluster_type != "kind" && $local_cluster_type != "minikube" ]]; then
    echo "Sorry! We only load images either onto kind or minikube clusters"
    exit 1

else
    for image in "${docker_images[@]}"; do 
        service="${image%%:*}"
        docker build -t $image "./services/$service"

        if [[ $local_cluster_type == "kind" ]]; then
            kind load docker-image $image --name $local_cluster_name
        elif [[ $local_cluster_type == "minikube" ]]; then
            minikube image load $image -p $local_cluster_name
        fi
    done
fi

# Pull database image and make it available to the local cluster
docker pull postgres:${POSTGRES_IMAGE_TAG}

if [[ $local_cluster_type == "kind" ]]; then
    kind load docker-image "postgres:${POSTGRES_IMAGE_TAG}" --name $local_cluster_name
elif [[ $local_cluster_type == "minikube" ]]; then
    minikube image load "postgres:${POSTGRES_IMAGE_TAG}" -p $local_cluster_name
else
    echo "Sorry! We only load images either onto kind or minikube clusters"
fi 
