# Dockerfile
FROM ubuntu:latest

# Install necessary packages and Ansible
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ansible/ansible -y && \
    apt-get update && \
    apt-get install -y ansible

# Set the working directory
WORKDIR /app

# Copy any necessary files (if needed)
COPY . .

# Default command
CMD ["ansible", "--version"]
