# Use the official Python image as a base image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /booking

# Copy the current directory contents into the container at /app
COPY . .

# Copy the requirements.txt file into the container at /app
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000 to allow outside access
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

