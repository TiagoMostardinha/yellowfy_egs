from fastapi import FastAPI, HTTPException
from fastapi.openapi.utils import get_openapi
from fastapi.responses import HTMLResponse
from models import Appointment
from typing import List, Optional

app = FastAPI()

# Dummy data storage
appointments = []

# CRUD operations
@app.post("/appointments/")
def create_appointment(appointment: Appointment):
    appointment.id = len(appointments) + 1
    appointments.append(appointment)
    return appointment

@app.get("/appointments/", response_model=List[Appointment])
def read_appointments(skip: int = 0, limit: int = 10):
    return appointments[skip:skip + limit]

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
