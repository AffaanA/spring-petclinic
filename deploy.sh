#!/bin/bash

set -e

APP_NAME="PetClinic"
SERVICE_NAME="petclinic"
DEPLOY_DIR="/opt/petclinic"
HEALTH_URL="http://localhost:8080/actuator/health"

build_application() {

    echo ""
    echo "[1/4] Building application..."

    ./mvnw clean package

    echo "✅ Build successful."
}

copy_artifact() {

    echo ""
    echo "[2/4] Copying application..."

    sudo cp target/*.jar "$DEPLOY_DIR/petclinic.jar"

    echo "✅ Artifact copied."
}

restart_service() {

    echo ""
    echo "[3/4] Restarting service..."

    sudo systemctl restart "$SERVICE_NAME"

    echo "✅ Service restarted."

}

verify_deployment() {

    echo ""
    echo "[4/4] Verifying deployment..."

    for i in {1..15}
    do
        if curl -fs "$HEALTH_URL" >/dev/null
        then
            echo "✅ Application is healthy."
            return
        fi

        echo "Waiting for application... ($i/15)"
        sleep 2
    done

    echo "❌ Application failed health check."
    exit 1
}

build_application

copy_artifact

restart_service

verify_deployment
echo ""
echo "Deployment completed."
