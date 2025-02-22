# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 10000

# Build image with SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["BlazorApp.csproj", "./"]
RUN dotnet restore "BlazorApp.csproj"

# Copy the entire project
COPY . .

# Build the project
RUN dotnet build "BlazorApp.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "BlazorApp.csproj" -c Release -o /app/publish

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variable for Render
ENV ASPNETCORE_URLS=http://+:10000

# Start the application
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
