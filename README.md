InformAG Technical Assessment – Azure DevOps Engineer

1.	Secure & Scalable Azure Architecture. 

<img width="1038" height="584" alt="image" src="https://github.com/user-attachments/assets/8521a47e-a270-4b0a-a2f8-1c24aeebe509" />

Architecture Components: 
•	IoT Devices: Pumps sending telemetry via MQTT
•	Azure IoT Hub: Central MQTT broker
•	Azure Kubernetes Service (AKS): Hosts containerized API & backend services
•	Docker: Containerize .NET Core APIs
•	Azure Container Registry (ACR): Stores container images
•	Azure Cosmos DB / Azure SQL / Azure Blob Storage: Stores structured and unstructured pump metadata
•	WAF: Secures and routes web/mobile traffic
•	Azure AD B2C: Provides multi-tenant authentication
•	Azure Key Vault: Secure secrets and certificates.
•	Azure Front Door: CDN and global load balancing

2.	Automated Monitoring & Anomaly Detection
Monitoring Stack:
•	Azure Monitor: Infrastructure metrics
•	Application Insights: API telemetry, tracing, failures
•	Log Analytics: Query logs across services
Anomaly Detection:
•	Stream Analytics: Detect thresholds (e.g., temperature & pressure)
•	Azure Metrics.
•	Alerts & Notifications:
o	Azure Monitor Alerts + Action Groups
o	Email, SMS, or Azure Logic Apps/Functions

3.	Build Pipeline:
•	The Azure DevOps pipeline builds the Docker image of C# backend API from the Docker file.
•	Pushes the image to Azure Container Registry (ACR).
•	Deploys the image as a container to Azure Kubernetes Service (AKS) using a blue-green method. The Kubernetes service points to the active environment based on the requirement. 

Blue/Green Setup:
We are maintaining 2 Kubernetes Deployments:
i.	pumpmaster-blue and pumpmaster-green. 
ii.	Here the kubernetes service routes the traffic by the label "app". 
a.	app: pumpmaster-blue or  app: pumpmaster-green
Smoke Tests: health checks which tests the APIs. 
Rollback: If green fails, the traffic still flows to blue. No actual "swap" happens unless we make change manually in the last stage.
Blue/Green switching:
i.	Deploy to pumpmaster-green.
ii.	Run health checks.
iii.	If green is healthy, update the service 
a.	"kubectl set selector svc/pumpmaster-service app=pumpmaster-green"
iv.	If rollback required, 
a.	"kubectl set selector svc/pumpmaster-service app=pumpmaster-blue"

4.	Troubleshooting & Security Incident Response
Scenario: Pump sending data, but not visible in frontend.
Troubleshooting Steps:
1.	IoT Hub:
•	Check device update time
•	Validate ingestion logs of telemetry
•	Check error logs or dropped messages
2.	Data Layer (Cosmos DB / SQL):
•	Inspect by Query for recent writes. 
3.	API Layer:
•	Check Application Insights for failed API calls and the response codes.
4.	Frontend:
•	Validate API call responses
•	Ensure no filters are hiding the data

5.	Security Considerations:
•	Secure IoT devices with certs or SAS tokens
•	Use TLS 1.2+ for MQTT and API traffic.
•	RBAC in AKS and Azure.
•	Store secrets in Azure Key Vault with strict access controls.


