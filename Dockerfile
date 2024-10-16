# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install Ansible
RUN apt-get update && apt-get install -y \
    ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Command to run when the container starts
CMD ["ansible", "--version"]
