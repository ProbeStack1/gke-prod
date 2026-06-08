# Dev GKE Deployment Pipeline Guide

This document is for creating the GitHub Actions pipeline for the new dev GKE environment. The prod workflow should not be reused as-is because it points to the prod project, prod Artifact Registry repo, prod cluster, prod namespace, and the `gke` branch.

## Branch

Create a dedicated `develop` branch and add the dev workflow there:

```bash
git checkout -b develop
git push -u origin develop
```

The workflow should trigger from `develop`, not `gke`.

## Dev Values

Use these values for the dev environment:

| Setting | Dev value |
| --- | --- |
| `PROJECT_ID` | `methodical-mark-482504-j3` |
| `ARTIFACT_REPO` | `probestack-dev-apps` |
| `ARTIFACT_REGISTRY` | `us-central1-docker.pkg.dev` |
| `GKE_CLUSTER` | `probestack-dev-cluster` |
| `GKE_LOCATION` | `us-central1-a` |
| `GKE_LOCATION_FLAG` | `--zone` |
| React Vite namespace | `probestack-dev` |

## Required GitHub/GCP Setup

Before enabling the workflow, create or verify these dev-side resources:

1. A GitHub OIDC Workload Identity provider in the dev GCP project.
2. A deployer service account in the dev GCP project, for example:

   `github-actions-deployer@methodical-mark-482504-j3.iam.gserviceaccount.com`

3. IAM roles for the deployer service account:

   `roles/artifactregistry.writer`

   `roles/container.developer`

   Any additional least-privilege role needed to update Kubernetes deployments in the dev cluster.

4. Workload Identity permission allowing the GitHub repository and `develop` branch to impersonate the dev deployer service account.

Do not use the prod Workload Identity provider or prod service account in the dev workflow.

## Dev React Vite Workflow

Create this file on the `develop` branch:

`.github/workflows/dev-gke-deploy-react-vite.yml`

Replace `<DEV_PROJECT_NUMBER>` and the pool/provider names if the dev Workload Identity setup uses different names.

```yaml
name: DEV GKE Deploy - React Vite

on:
  push:
    branches:
      - develop
  workflow_dispatch:

env:
  PROJECT_ID: methodical-mark-482504-j3
  ARTIFACT_REPO: probestack-dev-apps
  ARTIFACT_REGISTRY: us-central1-docker.pkg.dev
  SERVICE_NAME: react-vite
  GKE_CLUSTER: probestack-dev-cluster
  GKE_LOCATION: us-central1-a
  GKE_LOCATION_FLAG: --zone
  NAMESPACE: probestack-dev

jobs:
  deploy-dev-react:
    if: github.ref == 'refs/heads/develop'

    runs-on: ubuntu-latest

    permissions:
      contents: read
      id-token: write

    steps:
      - name: Checkout source code
        uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/<DEV_PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-pool/providers/github-provider
          service_account: github-actions-deployer@methodical-mark-482504-j3.iam.gserviceaccount.com
          token_format: access_token

      - name: Setup gcloud CLI
        uses: google-github-actions/setup-gcloud@v2

      - name: Install GKE auth plugin
        run: gcloud components install gke-gcloud-auth-plugin --quiet

      - name: Login to Artifact Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.ARTIFACT_REGISTRY }}
          username: oauth2accesstoken
          password: ${{ steps.auth.outputs.access_token }}

      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and Push Image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          provenance: false
          tags: |
            ${{ env.ARTIFACT_REGISTRY }}/${{ env.PROJECT_ID }}/${{ env.ARTIFACT_REPO }}/${{ env.SERVICE_NAME }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Get GKE credentials
        run: |
          gcloud container clusters get-credentials ${{ env.GKE_CLUSTER }} \
            ${{ env.GKE_LOCATION_FLAG }} ${{ env.GKE_LOCATION }} \
            --project ${{ env.PROJECT_ID }}

      - name: Deploy react vite service
        run: |
          kubectl set image deployment/${{ env.SERVICE_NAME }} \
            ${{ env.SERVICE_NAME }}=${{ env.ARTIFACT_REGISTRY }}/${{ env.PROJECT_ID }}/${{ env.ARTIFACT_REPO }}/${{ env.SERVICE_NAME }}:${{ github.sha }} \
            -n ${{ env.NAMESPACE }}

      - name: Wait for deployment rollout
        run: |
          kubectl rollout status deployment/${{ env.SERVICE_NAME }} \
            -n ${{ env.NAMESPACE }}

      - name: Verify running pods
        run: |
          kubectl get pods -n ${{ env.NAMESPACE }}
```

## Adapting For Other Dev Services

Use the same workflow pattern for other services by changing `SERVICE_NAME`, `NAMESPACE`, and the Docker build context if that service has a different source directory.

Namespace mapping:

| Service group | Namespace |
| --- | --- |
| Probestack core and WSO2 services | `probestack-dev` |
| ForgeQ services | `forgeq-dev` |
| ForgeStudio services | `forgestudio-dev` |
| ForgeSphere services | `forgesphere-dev` |
| ForgeAI frontend | `forgeai-dev` |
| ForgeHub frontend | `forgehub-dev` |
| ForgeKonnect frontend | `forgekonnect-dev` |

Examples:

| Service | Namespace |
| --- | --- |
| `react-vite` | `probestack-dev` |
| `forgeshift-wso2-profile-config-service` | `probestack-dev` |
| `forgeq-ai-assistant-svc` | `forgeq-dev` |
| `fs-sdkgenerator-svc` | `forgestudio-dev` |
| `fs-collaboration-svc` | `forgestudio-dev` |
| `fsp-mcp-generation-svc` | `forgesphere-dev` |
| `fsp-gatewayonboarding-svc` | `forgesphere-dev` |
| `fsp-compliance-svc` | `forgesphere-dev` |
| `fsp-apigee-wrapper-svc` | `forgesphere-dev` |

## Dev Checklist

- Confirm the workflow runs only from `develop`.
- Confirm the image is pushed to `us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps`.
- Confirm the deployment namespace is a `*-dev` namespace.
- Confirm the workflow does not reference `probestack-prod`, `probestack-prod-apps`, `secure-production-app`, or the prod service account.
- After the first run, verify rollout with `kubectl rollout status` and check pods in the target namespace.
