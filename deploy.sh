NAMESPACE="registry.deti/egs-yellowfy/"
echo "Deploying in $HOST..."

echo "Building images..."
echo "  auth"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/auth:v1 ./auth/auth_app
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/auth-db:v1 ./auth/auth_db

echo "  announcements"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/announcements:v1 ./announcements/api

echo "  booking"
docker buildx build --platform linux/amd64 --network=host -t $NAMESPACE/booking:v1 ./Booking

echo "Deploying..."
