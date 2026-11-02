# e-com-polyglot-platform
Platform architecture for the demo e-commerce application avaialble in the e-com-polyglot repo

For development I have used a local Minikube cluster hence all commands present hereafter will mostly be tailored towards **minikube**!

## Pre-requisites

* Have either **minikube** or **kind** installed on your machine.

* Have **Helm** installed.

* To build and load the local images onto your cluster run the 'build-images.sh' in the **scripts** folder

## Startup

1) Run 'helm upgrade --install dev-release .\helm --namespace dev --create-namespace -f .\helm\values.yaml' (Note- update values.yaml with your Database credentials)

## Verifications

1) Run 'minikube tunnel' in a Terminal (do not close afterwards)