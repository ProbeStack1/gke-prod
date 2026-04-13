param(
    [string]$namespace = "forgestudio-prod"
)

$pods = kubectl get pods -n $namespace -o json | ConvertFrom-Json

foreach ($pod in $pods.items) {
    foreach ($container in $pod.spec.containers) {
        if ($container.env) {
            foreach ($env in $container.env) {
                $value = if ($env.value) { $env.value } else { "FROM_SECRET_OR_CONFIGMAP" }
                "$namespace | $($pod.metadata.name) | $($container.name) | $($env.name)=$value"
            }
        }
    }
}