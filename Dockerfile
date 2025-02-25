# Step 1: Build the Blazor WebAssembly project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the solution and project files
COPY BlazorApp.sln ./
COPY BlazorApp.Client/BlazorApp.Client.csproj BlazorApp.Client/
COPY BlazorApp.Server/BlazorApp.Server.csproj BlazorApp.Server/

# Restore the dependencies
RUN dotnet restore

# Copy the rest of the code and publish the Blazor WebAssembly app
COPY . ./
RUN dotnet publish BlazorApp.Client/BlazorApp.Client.csproj -c Release -o /app/publish

# Step 2: Serve the Blazor WebAssembly app using Nginx
FROM nginx:alpine AS final

# Copy the published files from the build container to the Nginx container
COPY --from=build /app/publish/wwwroot /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
