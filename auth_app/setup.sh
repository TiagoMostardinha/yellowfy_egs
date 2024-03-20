#!/bin/bash

# Create and activate virtual environment
virtualenv auth
source auth/bin/activate

# Install required packages
pip install -r requirements.txt

# Set FLASK_APP environment variable
export FLASK_APP="project"

# Run Flask app
flask run

