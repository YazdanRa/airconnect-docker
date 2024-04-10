FROM ubuntu:latest
LABEL authors="Yazdan Ranjbar"

# Update package list and install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip \
    libssl-dev \
    ca-certificates

# Download the latest release of AirConnect
RUN curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest | \
    grep "browser_download_url.*zip" | \
    cut -d : -f 2,3 | \
    tr -d \" | \
    wget -qi - -O airconnect.zip

# Unzip the downloaded file and set permissions
RUN unzip airconnect.zip -d /airconnect && \
    chmod +x /airconnect/aircast-linux-aarch64 && \
    rm airconnect.zip

# Clean up unnecessary packages and files
RUN apt-get remove --purge -y curl wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /airconnect
ENTRYPOINT ["./aircast-linux-aarch64"]
