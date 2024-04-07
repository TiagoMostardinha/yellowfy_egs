# Create an appointment
curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "service_type": "Service A", "date_time": "2024-03-10 09:00", "client_id": 1, "client_name": "John Doe", "contractor_name": "Alice", "contractor_contact": "alice@example.com", "contractor_id": 1, "duration": 1}' http://localhost:8000/appointments/

# Retrieve all appointments
curl http://localhost:8000/appointments/

# Retrieve a specific appointment
curl http://localhost:8000/appointments/1

# Update an appointment
curl -X PUT -H "Content-Type: application/json" -d '{"id": 1, "service_type": "Service B", "date_time": "2024-03-10 10:00", "client_id": 1, "client_name": "John Doe", "contractor_name": "Alice", "contractor_contact": "alice@example.com", "contractor_id": 1, "duration": 2}' http://localhost:8000/appointments/1

# Delete an appointment
curl -X DELETE http://localhost:8000/appointments/1

# Get appointments for a certain client
curl http://localhost:8000/client/1/appointments

# Get appointments for a certain contractor
curl http://localhost:8000/contractor/1/appointments

# Delete all appointments for a certain contractor
curl -X DELETE http://localhost:8000/contractor/1/appointments

# Send 20 POST requests to create appointments
for i in {1..20}; do
    curl -X POST -H "Content-Type: application/json" -d '{"id": '$i', "service_type": "Service A", "date_time": "2024-03-10 09:00", "client_id": 1, "client_name": "John Doe", "contractor_name": "Alice", "contractor_contact": "alice@example.com", "contractor_id": 1, "duration": 1}' http://localhost:8000/appointments/
    echo ""
done


