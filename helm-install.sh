#!/bin/bash
# export KUBERNETES_SKIP_WARN_ON_INSECURE_CONNECTION=true

# # Load the configuration file
# source config.yaml
# # Parse the batch size argument (if provided)
# if [ -n "$1" ]; then
#   batch_size="$1"
# else
#   # Default batch size if not provided
#   batch_size=3
# fi

# function create_apps {
#     for app_name in "$@"; do
#         argocd app create "$app_name" \
#             --repo "$repo" \
#             --revision "$branch_name" \
#             --path "$path/k8s1" \
#             --dest-server https://kubernetes.default.svc \
#             --project "$project_name" \
#             --values "$values_file" \
#             --dest-namespace "$dest_name_space"
#     done
# }

# function sync_apps {
#     for app_name in "$@"; do
#         argocd app sync "$app_name" --grpc-web
#     done
# }

# # Create apps in batches
# num_apps="${#app_names[@]}"
# num_batches=$(( (num_apps + batch_size - 1) / batch_size ))

# for (( batch=0; batch < num_batches; batch++ )); do
#     start_idx=$((batch * batch_size))
#     end_idx=$(( (batch + 1) * batch_size - 1))
#     apps_batch=("${app_names[@]:$start_idx:$batch_size}")

#     create_apps "${apps_batch[@]}"
# done

# sleep 30
# echo 'create completed'

# # Sync apps in batches
# for (( batch=0; batch < num_batches; batch++ )); do
#     start_idx=$((batch * batch_size))
#     end_idx=$(( (batch + 1) * batch_size - 1))
#     apps_batch=("${app_names[@]:$start_idx:$batch_size}")

#     sync_apps "${apps_batch[@]}"
# done

# echo 'sync complete'

# ====================================================== #
# =======================================================#

#!/bin/bash
# export KUBERNETES_SKIP_WARN_ON_INSECURE_CONNECTION=true

# # Load the configuration file
# source config.yaml

# # Parse the batch size argument (if provided)
# if [ -n "$1" ]; then
#   batch_size="$1"
# else
#   # Default batch size if not provided
#   batch_size=3
# fi

# function retry {
#     local n=1
#     local max=5
#     local delay=15
#     while true; do
#         "$@" && break || {
#             if [[ $n -lt $max ]]; then
#                 ((n++))
#                 echo "Command failed. Attempt $n/$max:"
#                 sleep $delay;
#             else
#                 echo "The command has failed after $n attempts."
#                 return 1
#             fi
#         }
#     done
# }

# function create_apps {
#     for app_name in "$@"; do
#         retry argocd app create "$app_name" \
#             --repo "$repo" \
#             --revision "$branch_name" \
#             --path "$path/k8s1" \
#             --dest-server https://kubernetes.default.svc \
#             --project "$project_name" \
#             --values "$values_file" \
#             --dest-namespace "$dest_name_space"
#     done
# }

# function sync_apps {
#     for app_name in "$@"; do
#         retry argocd app sync "$app_name" --grpc-web
#     done
# }

# # Create apps in batches
# num_apps="${#app_names[@]}"
# num_batches=$(( (num_apps + batch_size - 1) / batch_size ))

# for (( batch=0; batch < num_batches; batch++ )); do
#     start_idx=$((batch * batch_size))
#     end_idx=$(( (batch + 1) * batch_size - 1))
#     apps_batch=("${app_names[@]:$start_idx:$batch_size}")

#     create_apps "${apps_batch[@]}"
# done

# sleep 30
# echo 'create completed'

# # Sync apps in batches
# for (( batch=0; batch < num_batches; batch++ )); do
#     start_idx=$((batch * batch_size))
#     end_idx=$(( (batch + 1) * batch_size - 1))
#     apps_batch=("${app_names[@]:$start_idx:$batch_size}")

#     sync_apps "${apps_batch[@]}"
# done

# echo 'sync complete'

# ======================================================= #
# ======================================================= #

# !/bin/bash

# ArgoCD login
echo 'Log in to ArgoCD'
argocd login 127.0.0.1:8080 --username admin --password vC08kXnlIYFViHrn --auth-token qWpbyD9zppUvWd3mVkeEqs6ohKkjIaophRu2Ts95lSblscxCva6WJArxWxkgG8eE --insecure
export ARGOCD_OPTS="--insecure"

# Load the configuration file
echo 'Loading configs from file'
source config.yaml

# Parse the batch size argument (if provided)
if [ -n "$1" ]; then
  batch_size="$1"
else
  # Default batch size if not provided
  batch_size=3
fi

function retry {
    local n=1
    local max=5
    local delay=15
    while [ $n -le $max ]; do
        "$@" && break || {
            if [ $n -lt $max ]; then
                ((n++))
                echo "Command failed: . Attempt $n/$max:"
                sleep $delay
            else
                echo "The command has failed after $n attempts. Moving to the next app."
                return 1
            fi
        }
    done
}

function create_apps {
    for app_name in "$@"; do
        retry argocd app create "$app_name" \
            --repo "$repo" \
            --revision "$branch_name" \
            --path "$path/helm-evn-test1" \
            --dest-server https://kubernetes.default.svc \
            --project "$project_name" \
            --values "$values_file" \
            --dest-namespace "$dest_name_space"
    done
}

function sync_apps {
    for app_name in "$@"; do
        retry argocd app sync "$app_name"
    done
}

# Create apps in batches
num_apps="${#app_names[@]}"
num_batches=$(( (num_apps + batch_size - 1) / batch_size ))

for (( batch=0; batch < num_batches; batch++ )); do
    start_idx=$((batch * batch_size))
    end_idx=$(( (batch + 1) * batch_size - 1))
    apps_batch=("${app_names[@]:$start_idx:$batch_size}")

    create_apps "${apps_batch[@]}"
done

sleep 30
echo 'create completed'

# Sync apps in batches
for (( batch=0; batch < num_batches; batch++ )); do
    start_idx=$((batch * batch_size))
    end_idx=$(( (batch + 1) * batch_size - 1))
    apps_batch=("${app_names[@]:$start_idx:$batch_size}")

    sync_apps "${apps_batch[@]}"
done

echo 'sync complete'