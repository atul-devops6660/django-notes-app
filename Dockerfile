# Use a slim version to keep the image size down
FROM python:3.9-slim

# Set environment variables to optimize Python behavior
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app/backend

# Install system dependencies
# Combined into one RUN to keep image layers small
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
# Copying requirements first allows Docker to cache this layer
COPY requirements.txt .
RUN pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

EXPOSE 8000

# Use a shell script or a combined command for migrations and server start
CMD [ "python", "./manage.py", "runserver", "0.0.0.0:8000" ]
