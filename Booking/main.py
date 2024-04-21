from contextlib import asynccontextmanager
from datetime import datetime
from fastapi import FastAPI
from sqlmodel import Field, Session, SQLModel, create_engine, select

app = FastAPI()


class Appointments(SQLModel, table=True):
    id: int = Field(primary_key=True)
    client_id: int
    contractor_id: int
    date: datetime
    duration: int

#sql file
sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
connect_args = {"check_same_thread": False}
engine = create_engine(sqlite_url, echo=True, connect_args=connect_args)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)


def on_startup():
    create_db_and_tables()

@asynccontextmanager
async def lifespan():
    yield
    await on_startup()

@app.post("/appointments/")
def create_appointment(appointment: Appointments):
    with Session(engine) as session:
        session.add(appointment)
        return appointment

@app.get("/appointments/{appointment_id}")
def read_appointment(appointment_id: int):
    with Session(engine) as session:
        appointment = session.get(Appointments, appointment_id)
        return appointment

@app.get("/appointments/")
def read_appointments():
    with Session(engine) as session:
        appointments = session.exec(select(Appointments)).all()
        return appointments

@app.put("/appointments/{appointment_id}")
def update_appointment(appointment_id: int, appointment: Appointments):
    with Session(engine) as session:
        appointment_db = session.get(Appointments, appointment_id)
        appointment_db.client_id = appointment.client_id
        appointment_db.contractor_id = appointment.contractor_id
        appointment_db.date = appointment.date
        appointment_db.duration = appointment.duration
        session.add(appointment_db)
        return appointment_db

@app.delete("/appointments/{appointment_id}")
def delete_appointment(appointment_id: int):
    with Session(engine) as session:
        appointment = session.get(Appointments, appointment_id)
        session.delete(appointment)
        return appointment

#endpoint for checking that returns the available hours for a contractor for a specific day
@app.get("/appointments/available_hours/{contractor_id}/{date}")
def available_hours(contractor_id: int, date: datetime):
    with Session(engine) as session:
        appointments = session.exec(select(Appointments).where(Appointments.contractor_id == contractor_id)).all()
        return appointments
    

