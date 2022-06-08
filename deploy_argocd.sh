#!/bin/sh


# Install Argo CD 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


## Setup the acces to Argo CD server 
#kubectl wait deployment -n argocd argocd-server --for condition=Available=True

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
until [ -n "$(kubectl -n argocd get svc argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do 
    sleep 10 
done

## Login to ArgoCD server and change the default password of admin account 
ip=$(kubectl get service argocd-server -n argocd --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ip : $ip"
argocd login $(echo $ip) --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure

argocd account update-password --account admin --current-password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --new-password $(echo $PASSWD)

## echo argocd server url 
echo "connect to argocd vias this url : https://$ip"