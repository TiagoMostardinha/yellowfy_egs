from fastapi import FastAPI, HTTPException
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
