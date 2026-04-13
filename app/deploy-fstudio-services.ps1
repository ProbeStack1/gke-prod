Write-Host "Starting forgestudio Services Deployment..." -ForegroundColor Green

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
    kubectl rollout status deployment $name -n forgestudio-prod
}

$services = @(
    "fs_apispec_svc",
    "fs_apiwizard_svc",
    "fs_project_svc"
)

foreach ($svc in $services) {
    Deploy-Service $svc
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "All forgestudio services deployed successfully!" -ForegroundColor Green

Write-Host "Checking Kubernetes resources..." -ForegroundColor Cyan
kubectl get pods -n forgestudio-prod
kubectl get svc -n forgestudio-prod