notes for creating and using a dev env
=================

These notes are just for setting up a local instance for dev of this plugin
only - DO NOT USE THESE INSTRUCTIONS for any installation visible
to the Internet or any network - I'm using these on a K8D/K8S installation on
my laptop.

```bash
helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm install my-cicd concourse/concourse
```

```bash
NOTES:                                                                                                                                       
* Concourse can be accessed within your cluster, at 

port 8080: my-cicd-web.default.svc.cluster.local 
                                                                                                                                             
* From outside the cluster, run these commands in the same shell:                                                                          

    export POD_NAME=$(kubectl get pods --namespace default -l "app=my-cicd-web" -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward --namespace default $POD_NAME 8080:8080
    echo "Visit http://127.0.0.1:8080 to use Concourse"

Use the default "test" user with the default "test" password. 

```
