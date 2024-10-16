# Use a base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y ansible \
    && apt-get clean

# Copy your playbook and any other necessary files
COPY . .

# Define default command
CMD ["bash"]
