# cd applications
# helm upgrade --install bpr-v1 ./bpr-account-getaccountinfo -n helm-deployments
# helm upgrade --install helm-evn-v1 ./helm-evn-test1 -n helm-deployments
# helm upgrade --install k8s1-v1 ./k8s1 -n helm-deployments


#!/bin/bash
export KUBERNETES_SKIP_WARN_ON_INSECURE_CONNECTION=true
# MAX_RETRIES=3
# TIMEOUT_SECONDS=60

# function create_argocd_app_with_retry {
#   local app_name=$1
#   local repo_url=$2
#   local app_path=$3

#   local attempt=1

#   while [[ $attempt -le $MAX_RETRIES ]]; do
#     echo "Creating Argo CD app: $app_name (Attempt: $attempt)"

#     # Execute the argocd app create command with a timeout
#     timeout $TIMEOUT_SECONDS argocd app create $app_name \
#       --repo $repo_url \
#       --path $app_path \
#       --dest-server https://kubernetes.default.svc \
#       --dest-namespace default

#     exit_code=$?

#     if [[ $exit_code -eq 0 ]]; then
#       echo "Successfully created Argo CD app: $app_name"
#       return 0
#     else
#       echo "Error creating Argo CD app: $app_name (Attempt: $attempt)"
#       ((attempt++))
#     fi
#   done

#   echo "Failed to create Argo CD app: $app_name after $MAX_RETRIES attempts"
#   return 1
# }

# # Define an array to hold the app_names
# app_names=("k8s1" "helm-evn-test1" "bpr-account-getaccountinfo")


# argocd login 127.0.0.1:8080 --username admin --password vC08kXnlIYFViHrn --auth-token Gr6lHHH90xx9JMUraXboYxCl2P1RoDPlLgFj8QXsBCYTqsKpJ8KEzK9lZaBegCZe

# # Loop through the array and create apps with retry and timeout
# for app_name in "${app_names[@]}"; do
#   create_argocd_app_with_retry "$app_name" "https://github.com/karisa537/HelmChartsRepos.git" "applications/$app_name"
# done

# echo 'completed'


#!/bin/bash

# MAX_RETRIES=3
# TIMEOUT_SECONDS=60

# function sync_argocd_app_with_retry {
#   local app_name=$1

#   local attempt=1

#   while [[ $attempt -le $MAX_RETRIES ]]; do
#     echo "Syncing Argo CD app: $app_name (Attempt: $attempt)"

#     # Execute the argocd app sync command with a timeout
#     timeout $TIMEOUT_SECONDS argocd app sync $app_name

#     exit_code=$?

#     if [[ $exit_code -eq 0 ]]; then
#       echo "Successfully synced Argo CD app: $app_name"
#       return 0
#     else
#       echo "Error syncing Argo CD app: $app_name (Attempt: $attempt)"
#       ((attempt++))
#     fi
#   done

#   echo "Failed to sync Argo CD app: $app_name after $MAX_RETRIES attempts"
#   return 1
# }

# # Define the app_names array
# app_names=("k8s1" "helm-evn-test1" "bpr-account-getaccountinfo" "final-app")

# echo 'Create the applications' > logfile1.yml

# argocd login 127.0.0.1:8080 --username admin --password vC08kXnlIYFViHrn --auth-token Gr6lHHH90xx9JMUraXboYxCl2P1RoDPlLgFj8QXsBCYTqsKpJ8KEzK9lZaBegCZe

# # Loop through the array and sync apps with retry and timeout
# for app_name in "${app_names[@]}"; do
#   sync_argocd_app_with_retry "$app_name"
# done

# echo 'completed'

# function retry {
#     local n=1
#     local max=5
#     local delay=15
#     while true; do
#     "$@" && break || {
#     if [[ $n -lt $max ]]; then
#     ((n++))
#     echo "Command failed. Attempt $n/$max:"
#     sleep $delay;
#     else
#     fail "The command has failed after $n attempts."
#     fi
#     }
#     done
# }
# helm-evn-test1echo 'Create the applications' > logfile1.yml
# # argocd login 127.0.0.1:8080 --username admin --password vC08kXnlIYFViHrn --auth-token Gr6lHHH90xx9JMUraXboYxCl2P1RoDPlLgFj8QXsBCYTqsKpJ8KEzK9lZaBegCZe 

# argocd app create k8s1 --repo https://github.com/karisa537/HelmChartsRepos.git --path applications/k8s1 --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app create helm-evn-test1 --repo https://github.com/karisa537/HelmChartsRepos.git --path applications/helm-evn-test1 --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app create bpr-account-getaccountinfo --repo https://github.com/karisa537/HelmChartsRepos.git --path applications/bpr-account-getaccountinfo --dest-server https://kubernetes.default.svc --dest-namespace default

# sleep 30
# echo 'create completed'
# argocd app sync k8s1 helm-evn-test1 bpr-account-getaccountinfo
# echo 'sync complete'

#!/bin/bash

function retry {
    local n=1
    local max=5
    local delay=15
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "Command failed. Attempt $n/$max:"
                sleep $delay;
            else
                fail "The command has failed after $n attempts."
            fi
        }
    done
}


app_names=("k8s1" "helm-evn-test1" "bpr-account-getaccountinfo")
# argocd login 127.0.0.1:8080 --username admin --password vC08kXnlIYFViHrn --auth-token Gr6lHHH90xx9JMUraXboYxCl2P1RoDPlLgFj8QXsBCYTqsKpJ8KEzK9lZaBegCZe

# Loop through the array and create apps with retry
for app_name in "${app_names[@]}"; do
    retry argocd app create "$app_name" \
        --repo https://github.com/karisa537/HelmChartsRepos.git \
        --path "applications/$app_name" \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace default
done

sleep 30
echo 'create completed'

# Loop through the array and sync apps with retry
for app_name in "${app_names[@]}"; do
    retry argocd app sync "$app_name"
done

echo 'sync complete'