from fastapi import FastAPI, HTTPException, Depends
from fastapi.openapi.utils import get_openapi
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from typing import List
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models
from models import Appointment, AppointmentBase
from google.oauth2 import service_account
import googleapiclient.discovery


models.Base.metadata.create_all(bind=engine)

app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
# Initialize your FastAPI app
app = FastAPI()

# Mock functions to fetch client_email and private_key from another API
async def get_client_email():
    # Call the external API to fetch client_email
    # For demonstration purposes, returning a mock client_email
    return "your_client_email@example.com"

async def get_private_key():
    # Call the external API to fetch private_key
    # For demonstration purposes, returning a mock private_key
    return "your_private_key"


# Function to import appointments to Google Calendar
def import_to_google_calendar(appointments: List[Appointment], client_email: str, private_key: str):
    credentials = service_account.Credentials.from_service_account_info({
        "client_email": client_email,
        "private_key": private_key,
        "scopes": ["https://www.googleapis.com/auth/calendar"],
    })

    service = googleapiclient.discovery.build("calendar", "v3", credentials=credentials)

    for appointment in appointments:
        event = {
            'summary': appointment.title,
            'description': appointment.description,
            'start': {
                'dateTime': appointment.date_time.strftime('%Y-%m-%dT%H:%M:%S'),
                'timeZone': 'UTC',  # Change this to the appropriate timezone
            },
            'end': {
                'dateTime': (appointment.date_time + timedelta(hours=appointment.duration)).strftime('%Y-%m-%dT%H:%M:%S'),
                'timeZone': 'UTC',  # Change this to the appropriate timezone
            },
        }

        # Insert event
        event = service.events().insert(calendarId='primary', body=event).execute()
        print('Event created: %s' % (event.get('htmlLink')))

# Endpoint to import appointments to Google Calendar
@app.post("/import-appointments-to-google-calendar/")
def import_appointments_to_google_calendar(client_email: str = Depends(get_client_email),
                                           private_key: str = Depends(get_private_key)):
    db = SessionLocal()
    appointments = db.query(Appointment).all()
    import_to_google_calendar(appointments, client_email, private_key)
    return {"message": "Appointments imported to Google Calendar successfully"}


# Helper function to check for overlapping appointments
def check_overlapping_appointments(new_appointment: Appointment, db):
    new_start_time = new_appointment.date_time
    new_end_time = new_start_time + timedelta(hours=new_appointment.duration)

    existing_appointments = db.query(Appointment).filter(
        Appointment.contractor_id == new_appointment.contractor_id,
        Appointment.date_time >= new_start_time,
        Appointment.date_time < new_end_time
    ).all()

    for existing_appointment in existing_appointments:
        existing_end_time = existing_appointment.date_time + timedelta(hours=existing_appointment.duration)
        if (new_start_time >= existing_appointment.date_time and new_start_time < existing_end_time) or \
                (existing_appointment.date_time >= new_start_time and existing_appointment.date_time < new_end_time):
            raise HTTPException(status_code=400, detail="Appointment time slot is not available")

# CRUD operations
@app.post("/appointments/", response_model=Appointment)
def create_appointment(appointment: Appointment):
    db = SessionLocal()
    check_overlapping_appointments(appointment, db)
    db.add(appointment)
    db.commit()
    db.refresh(appointment)
    return None

@app.get("/appointments/", response_model=List[Appointment])
def read_appointments(skip: int = 0, limit: int = 10):
    db = SessionLocal()
    return db.query(Appointment).offset(skip).limit(limit).all()

@app.get("/appointments/{appointment_id}", response_model=Appointment)
def read_appointment(appointment_id: int):
    db = SessionLocal()
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if appointment is None:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return appointment

@app.put("/appointments/{appointment_id}")
def update_appointment(appointment_id: int, appointment: Appointment):
    db = SessionLocal()
    db_appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if db_appointment is None:
        raise HTTPException(status_code=404, detail="Appointment not found")
    for attr, value in appointment.dict().items():
        setattr(db_appointment, attr, value)
    db.commit()
    return {"message": "Appointment updated successfully"}

@app.delete("/appointments/{appointment_id}")
def delete_appointment(appointment_id: int):
    db = SessionLocal()
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if appointment is None:
        raise HTTPException(status_code=404, detail="Appointment not found")
    db.delete(appointment)
    db.commit()
    return {"message": "Appointment deleted successfully"}
