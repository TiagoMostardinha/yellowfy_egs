#!/bin/bash
NAMESPACE="registry.deti/egs-yellowfy"

AUTH_VERSION="v8"
ANNOUNCEMENTS_VERSION="v11"
NGINX_VERSION="v3"

echo "Deleting previous deployment..."
kubectl delete -f ./deployment/deployment.yaml

echo "Deploying in $NAMESPACE..."

echo "Building images..."
echo "  auth"
docker buildx build --no-cache --platform linux/amd64 --network=host -t $NAMESPACE/auth:$AUTH_VERSION ./auth/auth_app
docker buildx build --no-cache --platform linux/amd64 --network=host -t $NAMESPACE/auth-db:$AUTH_VERSION ./auth/auth_db

echo "  announcements"
docker buildx build --no-cache --platform linux/amd64 --network=host -t $NAMESPACE/announcements:$ANNOUNCEMENTS_VERSION ./announcements/api

# echo "  booking"
# docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/booking:v1 ./Booking/Dockerfile
# docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/mysql:v1 ./Booking/Dockerfile.mysql

echo "  nginx"
docker buildx build --no-cache --platform linux/amd64 --network=host -t $NAMESPACE/nginx:$NGINX_VERSION -f ./deployment/Dockerfile.nginx ./deployment

echo "Deploying..."
docker push $NAMESPACE/auth:$AUTH_VERSION
docker push $NAMESPACE/auth-db:$AUTH_VERSION
docker push $NAMESPACE/announcements:$ANNOUNCEMENTS_VERSION
# docker push $NAMESPACE/booking:v1
# docker push $NAMESPACE/mysql:v1
docker push $NAMESPACE/nginx:$NGINX_VERSION

echo "Applying deployment in $NAMESPACE pod..."
kubectl apply -f ./deployment/deployment.yaml

echo "Done!"
