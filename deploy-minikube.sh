#!/usr/bin/env bash
set -eu

# Builds the app image and deploys it to the local minikube.
#
# Build the app first by running
#   USE_DOCKER=yes ./build.sh
#
# This is a hacky script as it uses the minikube's docker engine
# so we can avoid pushing to any remote registries.

# Dir of this script
declare ROOT_DIR=$(cd $(dirname ${BASH_SOURCE}) && pwd)

declare IMAGE_NAME="philip-app:latest"

echo "building image ${IMAGE_NAME}"
(
    # Use minikube's docker
    eval $(minikube docker-env)

    set -x
    docker build --tag ${IMAGE_NAME} .
)

# since this is a hack and we don't use versions
# remove existing deployment first to force the
# restart in case we updated our image.
echo "removing existing deployment"
(
    set -x
    kubectl scale deployment philip-app-deployment --replicas=0 || true
)


echo "deploying to cluster"
(
    set -x
    kubectl apply -f ${ROOT_DIR}/deploy-app.yaml
)

echo "pods"
(
    set -x
    kubectl get pods --selector=app=philip-app
)

echo "GREAT SUCCESS"

# tail the logs
sleep 2
(
    set -x
    kubectl logs --selector=app=philip-app -f
)
