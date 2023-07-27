# cd applications
# helm upgrade --install bpr-v1 ./bpr-account-getaccountinfo -n helm-deployments
# helm upgrade --install helm-evn-v1 ./helm-evn-test1 -n helm-deployments
# helm upgrade --install k8s1-v1 ./k8s1 -n helm-deployments


echo 'Create the applications' > logfile1.yml
argocd app create k8s1 --repo https://github.com/karisa537/HelmChartsRepos.git --path applications/k8s1 --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app create helm-evn-test1 --repo https://github.com/karisa537/HelmChartsRepos.git --path helm-evn-test1 --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app create bpr-account-getaccountinfo --repo https://github.com/karisa537/HelmChartsRepos.git --path applications/bpr-account-getaccountinfo --dest-server https://kubernetes.default.svc --dest-namespace default

sleep 30

echo 'sync the applications' > logfile.yml
argocd app sync k8s1 helm-evn-test1 bpr-account-getaccountinfo