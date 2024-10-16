# Use the official Ubuntu image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Update the package list and install required packages
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    apt-get clean

# Copy the contents of the current directory to the container
COPY . .

# Set the entrypoint (optional, depending on your needs)
CMD ["bash"]
