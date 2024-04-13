from flask_login import UserMixin
from app import db

class User(UserMixin, db.Model):

    id = db.Column(db.Integer, primary_key=True)  # primary keys are required by SQLAlchemy
    email = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(1000))  # Increased the length of password field
    name = db.Column(db.String(1000))
    looking_for_work = db.Column(db.Boolean, default=True)
    mobile_number = db.Column(db.String(20))
    google_token = db.Column(db.String(1000))
