from contextlib import asynccontextmanager
from datetime import datetime
from fastapi import FastAPI
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlmodel import Session, SQLModel, Field, create_engine, select


class appointments(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    client_id: int
    contractor_id: int
    date: datetime
    duration: int

# MySQL configuration
mysql_user = 'admin'
mysql_password = 'admin'
mysql_host = 'mysql'
mysql_port = '3306'
mysql_db = 'booking'

mysql_url = f"mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_host}:{mysql_port}/{mysql_db}"


# Create FastAPI app
app = FastAPI()

engine = create_engine(mysql_url, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
SQLModel.metadata.create_all(engine)

@app.post("/appointments/")
async def create_appointment(appointment: appointments):
     with Session(engine) as session:
        session.add(appointment)
        await session.commit()
        await session.refresh(appointment)
        return appointment

@app.get("/appointments/{appointment_id}")
async def read_appointment(appointment_id: int):
     with Session(engine) as session:
        statement = select(appointments).where(appointments.id == appointment_id)
        appointment = await session.exec(statement).first()
        return appointment

@app.get("/appointments/")
async def read_appointments():
     with Session(engine) as session:
        appointments_list = session.exec(select(appointments)).all()
        return appointments_list

@app.put("/appointments/{appointment_id}")
async def update_appointment(appointment_id: int, appointment: appointments):
     with Session(engine) as session:
        statement = select(appointments).where(appointments.id == appointment_id)
        appointment_db = await session.exec(statement).first()
        appointment_db.client_id = appointment.client_id
        appointment_db.contractor_id = appointment.contractor_id
        appointment_db.date = appointment.date
        appointment_db.duration = appointment.duration
        await session.commit()
        return appointment_db

@app.delete("/appointments/{appointment_id}")
async def delete_appointment(appointment_id: int):
     with Session(engine) as session:
        statement = select(appointments).where(appointments.id == appointment_id)
        appointment = await session.exec(statement).first()
        await session.delete(appointment)
        await session.commit()
        return appointment

@app.get("/appointments/available_hours/{contractor_id}/{date}")
async def available_hours(contractor_id: int, date: datetime):
     with Session(engine) as session:
        statement = select(appointments).where(appointments.contractor_id == contractor_id, appointments.date == date)
        appointments = await session.exec(statement).all()
        return appointments
