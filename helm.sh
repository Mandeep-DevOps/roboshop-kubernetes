if [ "$1" == "install" ]; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add elastic https://helm.elastic.co

  helm repo update

  helm upgrade -i ngx-ingres ingress-nginx/ingress-nginx
  kubectl apply -f external-dns.yml
  helm install filebeat elastic/filebeat -f filebeat.yml
fi

if [ "$1" == "delete" ]; then
  helm uninstall ngx-ingres
  kubectl delete -f external-dns.yml

fi
