# Use official .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the solution file (Ensure it exists!)
COPY BlazorApp.sln .  

# Copy project files
COPY BlazorApp.Shared/ BlazorApp.Shared/
COPY BlazorApp.Client/ BlazorApp.Client/
COPY BlazorApp.Server/ BlazorApp.Server/

# Restore dependencies
RUN dotnet restore BlazorApp.Server/BlazorApp.Server.csproj

# Copy the entire source code
COPY . .

# Build the application
RUN dotnet build BlazorApp.Server/BlazorApp.Server.csproj -c Release -o /app/build

# Publish the application
RUN dotnet publish BlazorApp.Server/BlazorApp.Server.csproj -c Release -o /app/publish

# Use a lightweight runtime image for deployment
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Set the entry point
ENTRYPOINT ["dotnet", "BlazorApp.Server.dll"]
