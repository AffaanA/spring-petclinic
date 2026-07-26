#!/bin/bash

set -e

APP_SERVER="ubuntu@172.31.38.38"
APP_DIR="/opt/petclinic"
SERVICE_NAME="petclinic"
JAR_FILE=$(ls target/*.jar)

echo "=================================="
echo "Deploying PetClinic"
echo "=================================="

echo "[1/4] Copying JAR to server..."

scp -i ~/.ssh/id_ed25519_deploy \
    "$JAR_FILE" \
    ${APP_SERVER}:/tmp/petclinic.jar

echo "[2/4] Installing application..."

ssh -i ~/.ssh/id_ed25519_deploy ${APP_SERVER} <<EOF
sudo mv /tmp/petclinic.jar ${APP_DIR}/petclinic.jar
sudo chown petclinic:petclinic ${APP_DIR}/petclinic.jar
EOF

echo "[3/4] Restarting service..."

ssh -i ~/.ssh/id_ed25519_deploy ${APP_SERVER} <<EOF
sudo systemctl restart ${SERVICE_NAME}
EOF

echo "[4/4] Checking application health..."

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
echo "Deployment completed successfully."
