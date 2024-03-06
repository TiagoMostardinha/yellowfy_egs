# models.py

from pydantic import BaseModel
from typing import Optional

class Appointment(BaseModel):
    id: int
    service_type: str
    date_time: str
    client_name: str
    contractor_name: str
    contractor_contact: str
    details: Optional[str] = None

