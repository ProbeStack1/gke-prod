Write-Host "Starting Secure devuction Services Deployment..." -ForegroundColor Green

function Deploy-Service {
param (
[string]$name
)

```
Write-Host "----------------------------------------" -ForegroundColor Yellow
Write-Host "Deploying $name" -ForegroundColor Cyan

# Apply Deployment
terraform apply -auto-approve -target="kubernetes_deployment_v1.$name"

# Apply Service
terraform apply -auto-approve -target="kubernetes_service_v1.$name"

# Apply BackendConfig (IMPORTANT for timeout)
$backend = "${name}_backend_config"
terraform apply -auto-approve -target="kubectl_manifest.$backend"

# Wait for rollout
kubectl rollout status deployment $name -n probestack-dev
```

}

# 🔹 List all your services here

$services = @(
"probestack_apigee_assessment_service",
"probestack_apigee_discovery_service",
"probestack_profile_config_service",
"probestack_apigee_migration_service",
"probestack_apigee_deployment_service",
"apigee_cutover",
"apigee_edge_mock_service"
)

foreach ($svc in $services) {
Deploy-Service $svc
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "All Secure devuction services deployed successfully!" -ForegroundColor Green

Write-Host "Checking Kubernetes resources..." -ForegroundColor Cyan
kubectl get pods -n probestack-dev
kubectl get svc -n probestack-dev
