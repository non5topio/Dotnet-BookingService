FROM mcr.microsoft.com/dotnet/sdk:2.1 AS test

WORKDIR /app

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip curl

# Install cover-agent
RUN pip3 install cover-agent

# Copy solution and project files
COPY *.sln ./
COPY BookingService/*.csproj ./BookingService/
COPY BookingService.Tests/*.csproj ./BookingService.Tests/
COPY client/BookingService.Client/src/BookingService.Client/*.csproj ./client/BookingService.Client/src/BookingService.Client/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the code
COPY . .

# Install ReportGenerator tool
RUN dotnet tool install -g dotnet-reportgenerator-globaltool

# Add dotnet tools to PATH
ENV PATH="${PATH}:/root/.dotnet/tools"

# Run tests with coverage
CMD ["bash", "-c", "echo GLIBC VERSION && ldd --version && echo GLIBC VERSION CHECK && dotnet test"]