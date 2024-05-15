#!/bin/bash
NAMESPACE="registry.deti/egs-yellowfy/"

echo "Deleting previous deployment..."
kubectl delete -f ./deployment/deployment.yaml

echo "Deploying in $NAMESPACE..."

echo "Building images..."
echo "  auth"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/auth:v1 ./auth/auth_app
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/auth-db:v1 ./auth/auth_db

echo "  announcements"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/announcements:v1 ./announcements/api

echo "  booking"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/booking:v1 ./Booking

echo "  nginx"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/nginx:v1 -f ./deployment/Dockerfile.nginx ./deployment

echo "Deploying..."
docker push $NAMESPACE/auth:v1
docker push $NAMESPACE/auth-db:v1
docker push $NAMESPACE/announcements:v1
docker push $NAMESPACE/booking:v1
docker push $NAMESPACE/nginx:v1

echo "Applying deployment in $NAMESPACE pod..."
kubectl apply -f ./deployment/deployment.yaml

echo "Done!"