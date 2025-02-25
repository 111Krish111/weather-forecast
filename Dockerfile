# Use the official .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy solution and project files
COPY *.sln ./
COPY BlazorApp.Server/BlazorApp.Server.csproj BlazorApp.Server/
COPY BlazorApp.Client/BlazorApp.Client.csproj BlazorApp.Client/
COPY BlazorApp.Shared/BlazorApp.Shared.csproj BlazorApp.Shared/

# Restore dependencies
RUN dotnet restore BlazorApp.Server/BlazorApp.Server.csproj

# Copy all source code and build
COPY . ./
RUN dotnet publish BlazorApp.Server/BlazorApp.Server.csproj -c Release -o /publish

# Use the official .NET runtime to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /publish .

# Expose ports
EXPOSE 80
EXPOSE 443

# Start the server
ENTRYPOINT ["dotnet", "BlazorApp.Server.dll"]
