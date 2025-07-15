FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:2.1 AS test

WORKDIR /app

# Set environment variables for better compatibility
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# Install Python and dependencies
RUN apt-get update -qq && \
    apt-get install -y python3 python3-pip curl wget && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy all source code directly
COPY . .

# Install ReportGenerator tool for coverage reports (optional, may fail but that's ok)
RUN dotnet tool install -g dotnet-reportgenerator-globaltool --verbosity normal || echo "ReportGenerator installation failed, continuing..."

# Add dotnet tools to PATH
ENV PATH="${PATH}:/root/.dotnet/tools"

# Verify installations
RUN echo "=== Verifying installations ===" && \
    dotnet --info && \
    python3 --version

CMD ["bash", "-c", "echo 'Environment ready for test generation' && dotnet --info && echo 'Source code available for analysis' && ls -la"]