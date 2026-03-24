Write-Host "Starting ForgeQ Services Deployment..." -ForegroundColor Green

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
    kubectl rollout status deployment $name -n forgeq-prod
}

$services = @(
    "fq_user_mgmt_svc",
    "fq_request_mgmt_svc",
    "fq_collection_mgmt_svc",
    "fq_workspace_mgmt_svc",
    "fq_monitor_mgmt_svc",
    "fq_mock_mgmt_svc",
    "fq_webhooks_mgmt_svc",
    "fq_environment_mgmt_svc",
    "fq_activity_mgmt_svc",
    "fq_documentation_mgmt_svc",
    "fq_collaboration_mgmt_svc"
)

foreach ($svc in $services) {
    Deploy-Service $svc
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "All ForgeQ services deployed successfully!" -ForegroundColor Green

Write-Host "Checking Kubernetes resources..." -ForegroundColor Cyan
kubectl get pods -n forgeq-prod
kubectl get svc -n forgeq-prod