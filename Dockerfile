FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

WORKDIR /app

EXPOSE 80



FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

COPY ["BlazorApp/BlazorApp.csproj", "BlazorApp/"]

RUN dotnet restore "BlazorApp/BlazorApp.csproj"

COPY . .

WORKDIR "/src/BlazorApp"

RUN dotnet build "BlazorApp.csproj" -c Release -o /app/build



FROM build AS publish

RUN dotnet publish "BlazorApp.csproj" -c Release -o /app/publish



FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "BlazorApp.dll"]