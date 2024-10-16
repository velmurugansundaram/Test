# Use the official Ubuntu image as a base
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y ansible python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy any necessary files into the container (if needed)
# COPY . .

# Default command to run when starting the container
CMD ["bash"]
