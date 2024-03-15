aws eks update-kubeconfig --name dev-eks
if [ "$1" == "install" ]; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add elastic x
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update

  helm upgrade -i ngx-ingres ingress-nginx/ingress-nginx
  kubectl apply -f external-dns.yml
  helm upgrade -i filebeat elastic/filebeat -f filebeat.yml
  helm upgrade -i prometheus prometheus-community/kube-prometheus-stack -f prometheus.yml
fi

if [ "$1" == "uninstall" ]; then
  helm uninstall ngx-ingres
  kubectl delete -f external-dns.yml
  helm uninstall filebeat
  helm uninstall prometheus
fi
