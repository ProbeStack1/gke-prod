Write-Host "Starting forgekonnect Services Deployment..." -ForegroundColor Green

function Deploy-Service {
    param (
        [string]$name
    )

    Write-Host "----------------------------------------" -ForegroundColor Yellow
    Write-Host "Deploying $name" -ForegroundColor Cyan

    terraform apply -auto-approve -target="kubernetes_deployment_v1.$name"
    terraform apply -auto-approve -target="kubernetes_service_v1.$name"

    $backend = $name -replace "_svc$", "_backend"
    terraform apply -auto-approve -target="kubectl_manifest.$backend"

    # Wait for rollout (IMPORTANT)
    kubectl rollout status deployment $name -n forgekonnect-dev
}

$services = @(
    "forgekonnect-fe"
)

foreach ($svc in $services) {
    Deploy-Service $svc
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "All forgekonnect services deployed successfully!" -ForegroundColor Green

Write-Host "Checking Kubernetes resources..." -ForegroundColor Cyan
kubectl get pods -n forgekonnect-dev
kubectl get svc -n forgekonnect-dev