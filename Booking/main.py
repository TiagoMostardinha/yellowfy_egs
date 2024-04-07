from fastapi import FastAPI, HTTPException
from fastapi.openapi.utils import get_openapi
from fastapi.responses import HTMLResponse
from models import Appointment
from typing import List, Optional
from datetime import datetime, timedelta
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.openapi.models import OAuthFlows as OAuthFlowsModel
from fastapi.openapi.models import OAuthFlowPassword as OAuthFlowPasswordModel
import redis

app = FastAPI()

# Dummy data storage
appointments = []

redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

# Cache functions
def cache_client_token(client_id: int, token: str):
    redis_client.set(f"client:{client_id}", token)

def get_client_token(client_id: int):
    return redis_client.get(f"client:{client_id}")

def cache_nearby_contractor_token(contractor_id: int, token: str):
    redis_client.set(f"contractor:{contractor_id}", token)

def get_nearby_contractor_token(contractor_id: int):
    return redis_client.get(f"contractor:{contractor_id}")


# Endpoint to delete all appointments for a certain contractor in case of account deletion or suspension
@app.delete("/contractor/{contractor_id}/appointments")
def delete_contractor_appointments(contractor_id: int):
    global appointments
    appointments = [appointment for appointment in appointments if appointment.contractor_id != contractor_id]
    return {"message": f"All appointments for contractor {contractor_id} deleted successfully"}

# Helper function to check for overlapping appointments
def check_overlapping_appointments(new_appointment: Appointment):
    new_start_time = datetime.strptime(new_appointment.date_time, "%Y-%m-%d %H:%M")
    new_end_time = new_start_time + timedelta(hours=new_appointment.duration)  # Calculate end time based on duration
    
    for existing_appointment in appointments:
        existing_start_time = datetime.strptime(existing_appointment.date_time, "%Y-%m-%d %H:%M")
        existing_end_time = existing_start_time + timedelta(hours=existing_appointment.duration)  # Calculate end time based on duration
        
        if (new_appointment.contractor_id == existing_appointment.contractor_id and
            ((new_start_time >= existing_start_time and new_start_time < existing_end_time) or
             (existing_start_time >= new_start_time and existing_start_time < new_end_time))):
            raise HTTPException(status_code=400, detail="Appointment time slot is not available")

# CRUD operations
@app.post("/appointments/")
def create_appointment(appointment: Appointment):
    check_overlapping_appointments(appointment)
    appointment.id = len(appointments) + 1
    appointments.append(appointment)
    return appointment

@app.get("/appointments/", response_model=List[Appointment])
def read_appointments(skip: int = 0, limit: int = 10):
    return appointments[skip : skip + limit]

@app.get("/appointments/{appointment_id}", response_model=Appointment)
def read_appointment(appointment_id: int):
    for appointment in appointments:
        if appointment.id == appointment_id:
            return appointment
    raise HTTPException(status_code=404, detail="Appointment not found")

@app.put("/appointments/{appointment_id}")
def update_appointment(appointment_id: int, appointment: Appointment):
    for i, a in enumerate(appointments):
        if a.id == appointment_id:
            appointments[i] = appointment
            return {"message": "Appointment updated successfully"}
    raise HTTPException(status_code=404, detail="Appointment not found")

@app.delete("/appointments/{appointment_id}")
def delete_appointment(appointment_id: int):
    for i, appointment in enumerate(appointments):
        if appointment.id == appointment_id:
            del appointments[i]
            return {"message": "Appointment deleted successfully"}
    raise HTTPException(status_code=404, detail="Appointment not found")

# Endpoint to serve Swagger UI HTML
@app.get("/docs", response_class=HTMLResponse)
async def custom_swagger_ui_html():
    return get_swagger_ui_html(openapi_url="/openapi.json", title="API documentation")

# Endpoint to serve OpenAPI schema
@app.get("/openapi.json")
async def get_open_api_endpoint():
    return get_openapi(title="API documentation", version="1.0.0", routes=app.routes)

# Endpoint to get appointments for a certain client
@app.get("/client/{client_id}/appointments", response_model=List[Appointment])
def get_client_appointments(client_id: int):
    return [appointment for appointment in appointments if appointment.client_id == client_id]

# Endpoint to get appointments for a certain contractor
@app.get("/contractor/{contractor_id}/appointments", response_model=List[Appointment])
def get_contractor_appointments(contractor_id: int):
    return [appointment for appointment in appointments if appointment.contractor_id == contractor_id]
