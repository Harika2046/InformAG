Simple Azure DevOps Yaml pipeline. 

This pipeline builds the Docker image of C# backend API from the Docker file.
Pushes the image to Azure Container Registry (ACR).
Deploys the image as a container to Azure Kubernetes Service (AKS) using a blue-green method. The Kubernetes service points to the active environment based on the requirement. 

Blue/Green Setup: 
We are maintaining 2 Kubernetes Deployments: 
1. pumpmaster-blue and pumpmaster-green.
2. Here the kubernetes service routes the traffic by the label "app".
    `app: pumpmaster-blue` 
    `app: pumpmaster-green`

Smoke Tests:
health checks 

Rollback:
If green fails, the traffic still flows to blue. No actual "swap" happens unless we make change manually in the last stage.


Blue/Green switching: 
1. Deploy to pumpmaster-green.
2. Run health checks.
3. If green is healthy, update the service
"kubectl set selector svc/pumpmaster-service app=pumpmaster-green" 
4. If rollback required, 
"kubectl set selector svc/pumpmaster-service app=pumpmaster-blue"