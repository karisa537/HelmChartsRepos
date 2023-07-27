cd applications
helm upgrade --install bpr-v1 ./bpr-account-getaccountinfo -n helm-deployments
helm upgrade --install helm-evn-v1 ./helm-evn-test1 -n helm-deployments
helm upgrade --install k8s1-v1 ./k8s1 -n helm-deployments