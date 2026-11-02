# e-com-polyglot-platform
Platform architecture for the demo e-commerce application avaialble in the e-com-polyglot repo

For development I have used a local Minikube cluster hence all commands present hereafter will mostly be tailored towards **minikube**!

## Pre-requisites

* Have either **minikube** or **kind** installed on your machine.

* Have **Helm** installed.

* To build and load the local images onto your cluster run the 'build-images.sh' in the **scripts** folder

## Startup

1) Startup cluster with 'minikube start --driver=docker'

2) Run 'helm upgrade --install dev-release ./helm \\  
          --namespace dev \\  
          --create-namespace \\  
          -f .\helm\values.yaml'  
(Note- update values.yaml with your Database credentials) **OR**    
   'helm install \<release-name\> ./helm \\  
      --namespace \<namespace\>' \\  
      -f values.yaml'

## Verifications

1) Run 'minikube tunnel' in a Terminal (do not close afterwards)

2) Enable port forwarding for one/multiple/all services by running the below command, run in separate terminals for separate services:  
  'kubectl port-forward -n \<namespace\> svc/\<k8s-service-name\> \<host-port\>:\<service-port\>'

3) Run 'curl http://localhost:/\<host-port\>/health'; response should be status 200!

## Teardown/Re-vamp

1) Run 'helm uninstall \<release-name\>'

2) Run 'kubectl delete namespace \<namespace-created-for-deployment\>'

2) Run 'minikube stop'
