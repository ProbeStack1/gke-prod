Write-Host "Updating BackendConfig timeout for all services..." -ForegroundColor Green

function Update-BackendConfig {
    param (
        [string]$name
    )

    Write-Host "----------------------------------------" -ForegroundColor Yellow
    Write-Host "Updating BackendConfig for $name" -ForegroundColor Cyan

    $backend = "${name}_backend_config"

    terraform apply -auto-approve -target="kubectl_manifest.$backend"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to update BackendConfig for $name" -ForegroundColor Red
    } else {
        Write-Host "Successfully updated BackendConfig for $name" -ForegroundColor Green
    }
}

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
    Update-BackendConfig $svc
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "All BackendConfigs updated successfully!" -ForegroundColor Green
Write-Host "Note: Changes may take 1-3 minutes to reflect on Load Balancer." -ForegroundColor Cyan