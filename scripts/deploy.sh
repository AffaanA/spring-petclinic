#!/bin/bash

set -e

IMAGE_NAME="Affaana/petclinic"
IMAGE_TAG="${BUILD_NUMBER}"

APP_SERVER="ubuntu@172.31.38.38"
SSH_KEY="$HOME/.ssh/id_ed25519_deploy"

echo "===================================="
echo "Deploying version ${IMAGE_TAG}"
echo "===================================="

ssh -i ${SSH_KEY} ${APP_SERVER} << EOF

set -e

echo "Pulling latest image..."
docker pull ${IMAGE_NAME}:${IMAGE_TAG}

echo "Stopping old container..."
docker stop petclinic || true

echo "Removing old container..."
docker rm petclinic || true

echo "Starting new container..."
docker run -d \
    --name petclinic \
    --restart unless-stopped \
    -p 8080:8080 \
    ${IMAGE_NAME}:${IMAGE_TAG}

echo "Cleaning unused Docker images..."
docker image prune -f

echo "Deployment completed."

EOF

echo "Waiting for application..."

sleep 15

echo "Running Health Check..."

ssh -i ${SSH_KEY} ${APP_SERVER} "curl -f http://localhost:8080 >/dev/null"
echo "Application is healthy!"
