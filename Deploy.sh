#!/bin/bash
NAMESPACE="registry.deti/egs-yellowfy"

NGINX_VERSION="v3"
BOOKING_VERSION="v1"

echo "Deleting previous deployment..."
kubectl delete -f ./deployment/deploymentEDGAR.yaml

echo "Deploying in $NAMESPACE..."

echo "Building images..."

echo "  booking"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE:$BOOKING_VERSION -f booking/Dockerfile .
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/mysql:$BOOKING_VERSION -f booking/Dockerfile.mysql .

echo "  nginx"
docker buildx build --no-cache --platform linux/amd64 --network=host -t $NAMESPACE/nginx:$NGINX_VERSION -f ./deployment/Dockerfile.nginx ./deployment

echo "Deploying..."
docker push $NAMESPACE/booking:$BOOKING_VERSION
docker push $NAMESPACE/mysql:$BOOKING_VERSION
docker push $NAMESPACE/nginx:$NGINX_VERSION

echo "Applying deployment in $NAMESPACE pod..."
kubectl apply -f ./deployment/deploymentEDGAR.yaml

echo "Done!"
