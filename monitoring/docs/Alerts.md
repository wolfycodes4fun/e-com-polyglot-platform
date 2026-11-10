# AlertManager configuration

App alerts can be configured to be fired by creating a CR of PrometheusRule as shown in ./monitoring/app-alerts.yaml

To trigger an email to be sent as the alert:  

* A Gmail (or any other email provider's) app password must be created and preferably set as an environment variable.  
* Run command 
    kubectl apply -k kustomization.yaml  
  to create the smtp password as a k8s secret. This command needs to be run from the root of the projects. A .env file with the variable **SMTP_PASSWORD** needs to be available under the monitoring folder.
* Apply the alertmanager-values.yaml under the values folder with the command:
    helm upgrade --install monitoring-stack prometheus-community/kube-prometheus-stack \  
      --namespace monitoring \  
      --reuse-values \  
      -f .\monitoring\values\alertmanager-values.yaml
