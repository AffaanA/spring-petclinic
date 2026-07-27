#!/bin/bash

set -e

APP_SERVER="ubuntu@172.31.38.38"
IMAGE_NAME="petclinic"
IMAGE_TAG="${BUILD_NUMBER}"
IMAGE_FILE="petclinic.tar"

echo "=================================="
echo "Deploying PetClinic Docker Image"
echo "=================================="

echo "[1/5] Saving Docker image..."

docker save ${IMAGE_NAME}:${IMAGE_TAG} -o ${IMAGE_FILE}

echo "[2/5] Copying image to App Server..."

scp -i ~/.ssh/id_ed25519_deploy \
    ${IMAGE_FILE} \
    ${APP_SERVER}:~/

echo "[3/5] Loading image on App Server..."

ssh -i ~/.ssh/id_ed25519_deploy ${APP_SERVER} <<EOF

set -e

docker load -i ~/petclinic.tar

docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} >/dev/null

docker stop petclinic || true
docker rm petclinic || true

docker run -d \
    --name petclinic \
    -p 8080:8080 \
    ${IMAGE_NAME}:${IMAGE_TAG}

rm ~/petclinic.tar

EOF

echo "[4/5] Checking application health..."

ssh -i ~/.ssh/id_ed25519_deploy ${APP_SERVER} <<EOF

for i in {1..15}
do
    if curl -fs http://localhost:8080/actuator/health >/dev/null
    then
        echo "Application is healthy."
        exit 0
    fi

    sleep 2
done

echo "Application failed health check."
exit 1

EOF

echo ""
echo "=================================="
echo "Deployment completed successfully."
echo "=================================="
