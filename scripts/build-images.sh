#!/bin/bash
# Description: This script clones the e-com-polglot repo and builds the Docker images 
# for each of the defined services. It then makes those images available to be used by your
# kind or minikube cluster

# Path to clone the e-com-polyglot repo
ecom_polyglot_repo=$1
local_cluster_type=$2
local_cluster_name=$3
POSTGRES_IMAGE_TAG="${4:-17-alpine}"


cd $ecom_polyglot_repo && git clone git@github.com:wolfycodes4fun/e-com-polyglot.git \
&& cd e-com-polyglot

$docker_images=(
    "analytics-service:v1",
    "auth-service:v1",
    "catalog-service:v1",
    "inventory-service:v1",
    "notification-service:v1",
    "order-service:v1",
    "payment-service:v1"
)

for image in "${docker_images[@]}"; do 
    service="${image%%:*}"
    docker build -t $image "./services/$service"

    if [[ $local_cluster_type == "kind" ]]; then
        kind load docker-image $image --name $local_cluster_name
    elif [[ $local_cluster_type == "minikube" ]]; then
        minikube image load $image -p $local_cluster_name
    else
        echo "Sorry! We only load images either onto kind or minikube clusters"
    fi
done

# Pull database image and make it available to the local cluster
docker pull postgres:${POSTGRES_IMAGE_TAG}

if [[ $local_cluster_type == "kind" ]]; then
    kind load docker-image "postgres:${POSTGRES_IMAGE_TAG}" --name $local_cluster_name
elif [[ $local_cluster_type == "minikube" ]]; then
    minikube image load "postgres:${POSTGRES_IMAGE_TAG}" -p $local_cluster_name
else
    echo "Sorry! We only load images either onto kind or minikube clusters"
fi 
