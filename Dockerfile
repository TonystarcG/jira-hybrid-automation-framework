##FROM ubuntu:latest
##LABEL authors="hrsing"
##
##ENTRYPOINT ["top", "-b"]
#
## Use a lightweight Python base image
#FROM python:3.10-slim
#
## Set working directory inside the container
#WORKDIR /app
#
## Copy all files from your local project into the container
#COPY . /app
#
## Upgrade pip and install required Python packages
#RUN pip install --upgrade pip && \
#    pip install -r requirements.txt
#
## Optional: Install Doppler CLI if you're using Doppler secrets
#RUN curl -sLf --retry 3 --retry-delay 2 https://downloads.doppler.com/cli/install.sh | sh
#
## Set environment variable for Python path
#ENV PYTHONPATH=/app
#
## Allow DOPPLER_TOKEN to be injected at runtime
#ENV DOPPLER_TOKEN=""
#
## Run your specific Robot Framework test file
#CMD ["robot", "automation_framework/tests/hybrid/test_issues_hybrid_combined_ref1_minimal2_5_3November.robot"]

# Use a lightweight Python base image
FROM python:3.10-slim

# Set working directory inside the container
WORKDIR /app

# Copy all files from your local project into the container
COPY . /app

# Upgrade pip and install required Python packages
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Optional: Install Doppler CLI if you're using Doppler secrets
RUN curl -sLf --retry 3 --retry-delay 2 https://downloads.doppler.com/cli/install.sh | sh

# Set environment variable for Python path
ENV PYTHONPATH=/app

# Allow Doppler token to be injected at runtime
ENV DOPPLER_TOKEN=""

# Run your specific Robot Framework test file
CMD ["robot", "automation_framework/tests/hybrid/test_issues_hybrid_combined_ref1_minimal2_5_25October_1.robot"]