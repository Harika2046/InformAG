FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Assuming the below folder structure

COPY ["PumpMasterApi/PumpMasterApi.csproj", "PumpMasterApi/"]   
RUN dotnet restore "PumpMasterApi/PumpMasterApi.csproj"

COPY . .
WORKDIR "/src/PumpMasterApi"
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "PumpMasterApi.dll"]
