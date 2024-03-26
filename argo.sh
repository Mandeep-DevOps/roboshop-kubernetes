argocd login argocd.rdevopsb73.online --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) --insecure --grpc-web

for i in cart catalogue user payment shipping frontend ; do
  #argocd app create $i --repo https://github.com/raghudevopsb77/$i --path k8s --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse --sync-policy none --grpc-web

  argocd app create $i --repo https://github.com/raghudevopsb77/$i --path helm/chart --dest-namespace default --dest-server https://kubernetes.default.svc --grpc-web
  argocd app sync $i
done
