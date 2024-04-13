# models.py
from pydantic import BaseModel
from datetime import datetime
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class AppointmentBase(BaseModel):
    client_id: int
    contractor_id: int
    announcement_id: int
    date_time: datetime
    duration: int


class Appointment(AppointmentBase):
    id: int

    class Config:
        from_attributes = True
