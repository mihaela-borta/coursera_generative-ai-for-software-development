# Base image with Python and Node.js
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install system dependencies, including Node.js and npm
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies from requirements.txt
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN python -m jupyterlab build --dev-build=False --minimize=False
RUN python -m ipykernel install --user --name=genai_for_sw --display-name 'Python (GenAI for SW)'

# Copy the rest of your files
#COPY ./data /app/data
#COPY ./src /app/src

# Expose ports
EXPOSE 8080

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]