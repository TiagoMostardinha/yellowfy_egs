# models.py

from pydantic import BaseModel
from typing import Optional

class Appointment(BaseModel):
    id: int
    announcement_id: str
    date_time: str
    client_id: int
    contractor_id: int  
    duration: int

