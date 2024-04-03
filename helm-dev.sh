aws eks update-kubeconfig --name dev-eks
if [ "$1" == "install" ]; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add elastic https://helm.elastic.co
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo add autoscaler https://kubernetes.github.io/autoscaler
  helm repo update

  helm upgrade -i ngx-ingres ingress-nginx/ingress-nginx -f ingress.yaml
  kubectl apply -f external-dns-dev.yml
  helm upgrade -i filebeat elastic/filebeat -f filebeat.yml
  helm upgrade -i prometheus prometheus-community/kube-prometheus-stack -f prometheus-dev.yml
  helm upgrade -i node-autoscaler autoscaler/cluster-autoscaler --set 'autoDiscovery.clusterName'=dev-eks -f cluster-autoscaler-dev.yml
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  kubectl create ns argocd
  kubectl apply -f argocd-dev.yml -n argocd
fi

if [ "$1" == "uninstall" ]; then
  kubectl delete ns argocd
  helm uninstall ngx-ingres
  kubectl delete -f external-dns.yml
  helm uninstall filebeat
  helm uninstall prometheus
  helm uninstall node-autoscaler
fi

# Argocd Password
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# argocd login argocd.rdevopsb73.online --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) --insecure