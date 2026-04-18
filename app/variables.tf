variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The region of the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "probestack-cluster"
}

variable "domain_name" {
  description = "Temporary domain for new cluster during migration"
  type        = string
  default     = "prod.probestack.io"
}

variable "react_vite_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-vite:1384b3b4837460c9109cb8dc66c70ad362b7f517"
}

variable "react_admin_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-admin:11.0"
}

variable "api_code_generator_ui_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/api-code-generator-ui@sha256:e466d776750789a614255efb550645beef11c97611add6cdef5af25322857dc4"
}

variable "admin_backend_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/admin-backend:bd9ada80b2cab702e447db545fd13a7c75846719"
}

variable "apigee_cutover_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-cutover:25b75cb8a6e369caeeed7075d6016cf9c19e3e6c"
}

variable "apigee_edge_mock_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-edge-mock-service@sha256:cadd0a9f37aab8bb0e6b6c0be7e091d96b9febf7e714c71502440c8fa811a95e"
}

variable "probestack_apigee_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-assessment-service:d084e4a568cfee056a6b453496aecab8e913de00"
}

variable "probestack_apigee_deployment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-deployments-service@sha256:8f9b878f87d3c65038f852da8b3974a90256d85d0a139eb83513207cc8df6011"
}

variable "probestack_apigee_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-discovery-service:3b39b47195c161f7716456b5e8be2a0e80c030c2"
}

variable "probestack_apigee_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-migration-service:92693902f69398b4576ae96da1988c7e31f7cc4f"
}

variable "probestack_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-profile-config-service:570fa32ca50f53bca5723ba4367b166d6484579b"
}

variable "forgeq_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-fe@sha256:43ec306249e1c92e951973157de93d51694340bdebb9b45ff51e6dfbe432e9b2"
}

variable "fq_user_mgmt_svc_image" {
  description = "Docker image for fq-user-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-user-mgmt-svc@sha256:f29de52b8d321ed12142481e0d808f4f88c35b9b5851dfcd9e53eb59556da76c"
}

variable "fq_request_mgmt_svc_image" {
  description = "Docker image for fq-request-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-request-mgmt-svc@sha256:6e1be21434fbf68933732bd360531964283f20c643af91bba7b0c2ef25318bba"
}

variable "fq_collection_mgmt_svc_image" {
  description = "Docker image for fq-collection-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-collection-mgmt-svc@sha256:331288d6401cc18f95388b0692edd4282c022179be362ac91f646d547b3f008b"
}

variable "fq_workspace_mgmt_svc_image" {
  description = "Docker image for fq-workspace-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-workspace-mgmt-svc@sha256:dcaeb81f02be913548fb4ff3e0e1a62e5348105a4e99b1a5f7741b50b5a0e129"
}

variable "fq_monitor_mgmt_svc_image" {
  description = "Docker image for fq-monitor-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-monitor-management-service@sha256:dc81dade72ac91f935c06180bec92008e4be0a3e36879a4c2296c8b028fd34f2"
}

variable "fq_mock_mgmt_svc_image" {
  description = "Docker image for fq-mock-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-mock-mgmt-svc@sha256:e39425de2269186512d10663b48f012e02ecc29e1c3fb1572e8ac1cc4a961914"
}

variable "fq_webhooks_mgmt_svc_image" {
  description = "Docker image for fq-webhooks-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-environment-mgmt-svc@sha256:295ba80fe363c23becf59a8da1194696293b0a92e1748e9c137f2486558f469d"
}

variable "fq_environment_mgmt_svc_image" {
  description = "Docker image for fq-environment-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-environment-mgmt-svc@sha256:295ba80fe363c23becf59a8da1194696293b0a92e1748e9c137f2486558f469d"
}

variable "fq_activity_mgmt_svc_image" {
  description = "Docker image for fq-activity-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-environment-mgmt-svc@sha256:295ba80fe363c23becf59a8da1194696293b0a92e1748e9c137f2486558f469d"
}

variable "fq_documentation_mgmt_svc_image" {
  description = "Docker image for fq-documentation-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-documentation-management-service@sha256:4da5b7bbd69cbc824f7d229d2c87c2b75c3f079a1b50072d21c4f4e20f732083"
}

variable "fq_collaboration_mgmt_svc_image" {
  description = "Docker image for fq-collaboration-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-collection-mgmt-svc@sha256:331288d6401cc18f95388b0692edd4282c022179be362ac91f646d547b3f008b"
}

variable "fq_support_mgmt_svc_image" {
  description = "Docker image for fq-support-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-support-mgmt-svc:4435d6fd4285dfcabc50e5966837c5f558424883"
}

variable "fq_setting_mgmt_svc_image" {
  description = "Docker image for fq-setting-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-setting-mgmt-svc:d3a5eb4ef9a2615ee5a514fb73028c66fa875a18"
}

variable "fq_testfile_mgmt_svc_image" {
  description = "Docker image for fq-testfile-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-testfile-mgmt-svc:a9dbbc90bca47c8abfae41070a495d1ee494afc2"
}

variable "fq_testspec_mgmt_svc_image" {
  description = "Docker image for fq-testspec-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-testspec-mgmt-svc@sha256:88827c893da4373aa157926a5e3f05672ea18fb53b6ec7efb057c5973711fdbe"
}

variable "fq_dashboard_mgmt_svc_image" {
  description = "Docker image for fq-dashboard-mgmt-svc"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fq_functional_test_mgmt_svc_image" {
  description = "Docker image for fq_functional_test_mgmt_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-functional-test-mgmt-svc:ece8df50c00ac8e4d3699ccfeb68322b8663999a"
}

variable "fq_load_test_mgmt_svc_image" {
  description = "Docker image for fq_load_test_mgmt_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-load-test-mgmt-svc:9600bea8f42b922b4d990765535391c42376624a"
}

variable "forgestudio_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-fe@sha256:43ec306249e1c92e951973157de93d51694340bdebb9b45ff51e6dfbe432e9b2"
}

variable "fs_apispec_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fs-apispec-svc@sha256:9ffb7eab299d7a92e2cf2baa9473edcff63a23fdb426be3821e191f35809203a"
}

variable "fs_apiwizard_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fs-apiwizard-svc@sha256:029c6b73c468bacb12ef7fc83daf205ffdc12becc84ca8d6ebe377289ea6f278"
}

variable "fs_project_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fs-project-svc@sha256:1498643740a816a2da660ae9f4cbb8c3306d1212906354c2c5985c4c3fe11c63"
}

variable "fsp_api_design_svc_image" {
  description = "Docker image for fsp_api_design_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_api_development_svc_image" {
  description = "Docker image for fsp_api_developemnt_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_api_mock_svc_image" {
  description = "Docker image for fsp_api_mock_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_consumer_svc_image" {
  description = "Docker image for fsp_consumer_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_contract_testing_svc_image" {
  description = "Docker image for fsp_contract_testing_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_onboarding_svc_image" {
  description = "Docker image for fsp_onboarding_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_provider_api_svc_image" {
  description = "Docker image for fsp_provider_api_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_requirement_mgmt_svc_image" {
  description = "Docker image for fsp_requirement_mgmt_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "fsp_test_generation_svc_image" {
  description = "Docker image for fsp_test_generation_svc_image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

variable "forgesphere_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgesphere-fe@sha256:6f25b8cfabd77449cff8c75cf9c121831d3b10721aa85915581682d40916242a"
}

variable "forgeai_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-ai-gw:c56f6ff719d081e99e2b81defda11bb4ccfc05c0@sha256:8cf0b7d618f2a165308875b2509ceb8c326d00dc0c68f4bafcf3d3c74b09273a"
}

variable "forgekonnect_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-fe@sha256:43ec306249e1c92e951973157de93d51694340bdebb9b45ff51e6dfbe432e9b2"
}

variable "forgehub_fe_image" {
  type    = string
  default = " us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgehub-fe:dd9cc6b45287ff40e846851aebbecdc46c946c7b@sha256:4f2a87c0fc2d237ad71c563d5d2f2087bf59cd08335d2023fc450f83686c4a1f"
}

variable "cloudsql_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-g1-small"
}

variable "cloudsql_user" {
  type    = string
  default = "admin_dashboard"
}

variable "cloudsql_password" {
  type      = string
  sensitive = true
}

variable "mongodb_uri" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgeshift" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgeshift" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgestudio" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgestudio" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgesphere" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgesphere" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgeq" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgeq" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgeai" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgeai" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgehub" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgehub" {
  type      = string
  sensitive = true
}

variable "mongodb_uri_forgekonnect" {
  type      = string
  sensitive = true
}

variable "mongodb_config_db_forgekonnect" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret" {
  type      = string
  sensitive = true
}