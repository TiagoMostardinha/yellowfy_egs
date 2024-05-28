# Use the official Python image as a base image
FROM python:3.10-slim

#Create a directory /booking
RUN mkdir /bookingapp

# Set the working directory in the container
WORKDIR /bookingapp/

# Copy the current directory contents into the container
COPY . /bookingapp/

# Install dependencies
RUN pip install fastapi==0.68.0 uvicorn==0.15.0 sqlmodel==0.0.9 pymysql==1.0.2

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client

RUN pip install cryptography

# Expose port 8000 to allow outside access
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

