# Setting up/ Logging into Grafana

After running the cluster and setting up a tunnel to it from your localhost:

1) Run 'kubectl get services -n monitoring' and fetch for a service with **-grafana** in the name.
2) Run 'kubectl port-forward svc/\<grafana-service-name\> \<host-port\>:\<port\> -n monitoring'
3) Fetch the password secret by running 'kubectl get secrets -n monitoring | grep grafana'; this would typically be **monitoring-stack-grafana**
4) Decode the password by running   
    '[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String((kubectl get secret monitoring-stack-grafana -n monitoring -o jsonpath='{.data.admin-password}')))'
5) Log onto the Grafana dashboard on http://localhost:\<host-port\> with username as **admin** and the password fetched from above.

## PromQL queries for dashboards

RED metrics; request rate, error rate & latency will be shown for **auth** and **order** services.

* Orders - req/s (orders requests per second sorted by URI):  
    sum by (route) (
        rate(http_requests_total{job="orders", route!="/health"[5m]})
    )

* Auth - req/s (auth requests per second sorted by URI):  
    sum by (uri) (
        rate(http_server_requests_seconds_count{job="auth", uri!="/health"[5m]})
    )

* ErrorAuth (percentage of auth requests returning 5xx responses):  
    100 *
    sum(rate(http_server_requests_seconds_count{  
        job="auth",  
        status=~"5..",  
        uri!="/health"
    }[5m]))  
    /  
    sum(rate(http_server_requests_seconds_count{
        job="auth",  
        uri!="/health"  
    }[5m]))

* ErrorOrders (percentage of order requests returning 5xx responses):  
    100 *  
    sum(rate(http_requests_total{  
        job="orders",  
        status=~"5..",  
        route!="/health"  
    }[5m]))  
    /  
    sum(rate(http_requests_total{  
        job="orders",  
        route!="/health"  
    }[5m]))

