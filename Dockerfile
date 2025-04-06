# Use an official Python runtime as the base image
FROM python:3.10-alpine

# Install necessary build dependencies for Alpine
RUN apk update \
    && apk add --no-cache \
    pkgconfig \
    mariadb-dev \
    build-base \
    bash \
    && rm -rf /var/cache/apk/*  # Clean up the apk cache

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the wait-for-it script and make it executable
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh
# RUN apt-get update && apt-get install -y netcat


# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Expose the port Flask will run on
EXPOSE 5000

# Run the application with wait-for-it to wait for MySQL to be ready
CMD ["/wait-for-it.sh", "db:3306", "--", "flask", "run", "--host=0.0.0.0"]
