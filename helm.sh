aws eks update-kubeconfig --name dev-eks
if [ "$1" == "install" ]; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add elastic https://helm.elastic.co
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update

  helm upgrade -i ngx-ingres ingress-nginx/ingress-nginx
  kubectl apply -f external-dns.yml
  helm install filebeat elastic/filebeat -f filebeat.yml
  helm install prometheus prometheus-community/kube-prometheus-stack
fi

if [ "$1" == "uninstall" ]; then
  helm uninstall ngx-ingres
  kubectl delete -f external-dns.yml
  helm uninstall filebeat
  helm uninstall prometheus
fi
