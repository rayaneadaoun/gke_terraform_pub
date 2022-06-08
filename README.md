# GKE_Terraform
This project allows the creation of a gke cluster on the GCP cloud and the installation of a gitops tool argoCD , using terraform whose buckets are stored on gcs.

## Manual install of gke cluster 
### install gke cluster
#### Requirements:
- Connect to your gcp account with gcloud tools (you must install before gcloud)
```
$ gcloud auth application-default login
```
- Setup your variables in the file variables.tf

#### terrafrom command
```bash 
$ terraform init 
$ terraform workspace select gke_admin
$ terraform apply -auto-approve
```

### upload kube config file 
```bash 
$ gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```
### Deploy and acces kubernetes dashboard 

```bash 
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
```
Create a ClusterRoleBinding ressource to authenticate with acces token 
``` 
$ kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/main/kubernetes-dashboard-admin.rbac.yaml
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
```

Use the token display to connect to the dashbord 
To do this execute the commande "kubectl proxy" and use this url 
[Link text Here](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

## Automatic install of gke cluster 
Just push you commit and let the pipeline do the job. (see [.github/workflows/deploy.yml](.github/workflows/deploy.yml))

## Install and setup argocd in the gke cluster 
### Requirements
- Install kubectl and upload kube config file from the cluster gke (see above )
- Export the variables $PASSWD with the new password you will attribute to admin account , or add it in the script
- Install argocd cli tools, execute this command
```
$ curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
$ chmod +x /usr/local/bin/argocd
```
### launch the script 
```
$ sh deploy_argocd.sh
```
- the script will display the url of argocd server ,then connect with "admin" username

### Argocd Application template
- You can use the yml file template [application.yml](argocd_app_templates/application.yml) to link a private repo git to your argocd server on the k8s cluster.
- To do this , you have first to add you public deployment key in your private repo (give to the key a read-only right on the repo, it is recommended) 
- In the template [file](argocd_app_templates/application.yml) add your private key in a k8s sercret ressource. (you can use other secret management solutions such as volt ).
- Then deploy the application resource with kubectl 
```
$ kubectl apply -f argocd_app_templates/application.yml
```