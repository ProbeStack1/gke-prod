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
  default     = "dev.probestack.io"
}

# =========================
# Core UI / Backend
# =========================

variable "react_vite_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/react-vite@sha256:d07734a1f46953799be9d460efb4c278431149580aa273c0da2c5720f4b9b9fa"
}

variable "react_admin_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/react-admin@sha256:e39eeeed58136764f3988ab1e57c96dc804e83c2edfa8b3c4b707b7e622a7eb1"
}

variable "admin_backend_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/admin-backend@sha256:ec5d8678e5f002d70a62ce17dcb4319b66a706ab3308d619640de89a018c8525"
}

variable "api_code_generator_ui_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/api-code-generator-ui@sha256:2d15cd8d463729d2da533f17db9fa2b0a34b34ce68bb0c23eff3a7d486122c21"
}

# =========================
# Apigee
# =========================

variable "apigee_cutover_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/apigee-cutover@sha256:e9e40e9a5b883a37b15475903e65b509feac8bd4f2d170ef6ec52e2298255aee"
}

variable "apigee_edge_mock_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/apigee-edge-mock-service@sha256:cadd0a9f37aab8bb0e6b6c0be7e091d96b9febf7e714c71502440c8fa811a95e"
}

variable "probestack_apigee_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-apigee-assessment-service@sha256:7cb464a6b83c8b1b072cb38294e8032af3726e2c6abdeaf684c9fa02425fa21b"
}

variable "probestack_apigee_deployment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-apigee-deployments-service@sha256:053321802530900be66ef41f03e108741f45894946361d052da36b16cdffe41c"
}

variable "probestack_apigee_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-apigee-discovery-service@sha256:99f1c08945a45424e97b224c16cdf5d0d6e14fada813780d6fa6099bc9e331d4"
}

variable "probestack_apigee_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-apigee-migration-service@sha256:ac8b6de67fbffaadebaacf57ed5bcc953ed43d1a086297ec89cf33db8b102fbb"
}

variable "probestack_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-profile-config-service@sha256:b709a2853f5c4dd56063e6d371a8864600604297e6e2f124f4adb9ef9a0af182"
}

variable "forgeshift_wso2_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeshift-wso2-profile-config-service:latest"
}

variable "forgeshift_wso2_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-profile-config-service:570fa32ca50f53bca5723ba4367b166d6484579b"
}

variable "forgeshift_wso2_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeshift-wso2-assessment-service:latest"
}

variable "forgeshift_wso2_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeshift-wso2-migration-service:latest"
}
variable "forgeshift_wso2_validation_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeshift-wso2-validation-service:latest"
}
variable "forgeshift_wso2_cutover_service_image" {
  description = "Docker image for ForgesShift WSO2 cutover service"
  type        = string
  default     = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeshift-wso2-cutover-service:latest"
}

# =========================
# ForgeQ Core
# =========================

variable "forgeq_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-fe@sha256:52fac73b9decf7f3604f4261a0d791e8fedbdd74501e9143ef8a05a3c6f2f494"
}

variable "forgeq_workspace_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-workspace-mgmt-svc@sha256:dcaeb81f02be913548fb4ff3e0e1a62e5348105a4e99b1a5f7741b50b5a0e129"
}

variable "forgeq_ai_assistant_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-workspace-mgmt-svc@sha256:dcaeb81f02be913548fb4ff3e0e1a62e5348105a4e99b1a5f7741b50b5a0e129"
}

variable "forgeq_monitor_management_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-monitor-management-service@sha256:dc81dade72ac91f935c06180bec92008e4be0a3e36879a4c2296c8b028fd34f2"
}

variable "forgeq_documentation_management_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-documentation-management-service@sha256:4da5b7bbd69cbc824f7d229d2c87c2b75c3f079a1b50072d21c4f4e20f732083"
}

# =========================
# FQ Services
# =========================

variable "fq_user_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-user-mgmt-svc@sha256:22c161c0b337f8236cfbbe54aae2d04a5e1c4ac853a3a7ed8dde27968629c726"
}

variable "fq_request_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-request-mgmt-svc@sha256:cd36071cfebb20c77dfd197b124139461c61e5fe9d94468d3634c7e7986b379f"
}

variable "fq_collection_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-collection-mgmt-svc@sha256:ab7b16da6aeb35cc1e4a4ad627e8a72436b6cfeaa451f2cd117d26bececa734f"
}

variable "fq_dashboard_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-dashboard-mgmt-svc@sha256:362452f26d5da9a939fdce42565625c101d7b43b54fa3f1d3e553afd0034d818"
}

variable "fq_environment_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-environment-mgmt-svc@sha256:7c183dc3d3d5fcd8dca8ffdb5cd9ec169ed25f1dd7d35a97a6eebca69d01f9e9"
}

variable "fq_functional_test_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-functional-test-mgmt-svc@sha256:2dd2967d996139a4dff43ecd5fa7f68dc9dada5972eb07735509029a90817ea2"
}

variable "fq_load_test_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-load-test-mgmt-svc@sha256:90b811188d8ca92a8f1526cebd3ca80934cb6dd6977e7cb414a29c83079c815e"
}

variable "fq_mock_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-mock-mgmt-svc@sha256:1263350529a0439403914053b3196755b5437be3cad66274aed60cf78f957de5"
}

variable "fq_setting_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-setting-mgmt-svc@sha256:aacd798c8540d23d86970d6646f9e20a53429c92ae17711a3ccf8e5dadd183fe"
}

variable "fq_support_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-support-mgmt-svc@sha256:f66cd456b56ea415939b191e245e6cd477d046ab017861a885dd6d8df9c831c5"
}

variable "fq_testfile_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-testfile-mgmt-svc@sha256:1c314004af897fe57dad2f1788ae388ec240490f4e1bfceee9ce783a94285611"
}

variable "fq_testspec_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-testspec-mgmt-svc@sha256:a5e074027f8f00e7cb9848ecaf77ce10587d670ad5c8d56e4b85e7a5cff28549"
}
variable "fq_activity_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-environment-mgmt-svc@sha256:295ba80fe363c23becf59a8da1194696293b0a92e1748e9c137f2486558f469d"
}

variable "fq_collaboration_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-collection-mgmt-svc@sha256:331288d6401cc18f95388b0692edd4282c022179be362ac91f646d547b3f008b"
}

variable "fq_documentation_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-documentation-management-service@sha256:4da5b7bbd69cbc824f7d229d2c87c2b75c3f079a1b50072d21c4f4e20f732083"
}

variable "fq_monitor_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-monitor-management-service@sha256:dc81dade72ac91f935c06180bec92008e4be0a3e36879a4c2296c8b028fd34f2"
}

variable "fq_webhooks_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-environment-mgmt-svc@sha256:295ba80fe363c23becf59a8da1194696293b0a92e1748e9c137f2486558f469d"
}

variable "fq_workspace_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-workspace-mgmt-svc@sha256:dcaeb81f02be913548fb4ff3e0e1a62e5348105a4e99b1a5f7741b50b5a0e129"
}

variable "fs_apispec_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fs-apispec-svc@sha256:9ffb7eab299d7a92e2cf2baa9473edcff63a23fdb426be3821e191f35809203a"
}

variable "fs_apiwizard_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fs-apiwizard-svc@sha256:029c6b73c468bacb12ef7fc83daf205ffdc12becc84ca8d6ebe377289ea6f278"
}

variable "fs_project_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fs-project-svc@sha256:1498643740a816a2da660ae9f4cbb8c3306d1212906354c2c5985c4c3fe11c63"
}

variable "fs_sdkgenerator_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fs-sdkgenerator-svc:a1718273b367e2796251c8aa993cb3b91f90323d"
}

variable "fs_collaboration_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fs-collaboration-svc:latest"
}

# =========================
# FSP Services
# =========================

variable "fsp_api_design_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-api-design-svc@sha256:d9f973793d5c2c4fb64657ca66c0c05dae4be5c4c370736d69b75cd61456129f"
}

variable "fsp_api_development_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-api-development-svc@sha256:1540627643616d4413ae353bd1038793f6997c9f08b8706b10358dd581cb06cc"
}

variable "fsp_api_mock_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-api-mock-svc@sha256:98dc1d7bafc63814187b5ab7957c50aa898d1efaeecc50181f43225cfcc742ae"
}

variable "fsp_consumer_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-consumer-svc@sha256:3a7257db3706454a10ae3ede5c0ef500bf6926333e93917e575653813cd3e14c"
}

variable "fsp_contract_testing_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-contract-testing-svc@sha256:99d292668a660cb4be2e77c1913fb0f9bdc0672446c31fa10ce97c84caaa298e"
}

variable "fsp_onboarding_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-onboarding-svc@sha256:84ad38b80261b07bfa24c980aea118b8fb3b17f0cfc9c832b45b54309b51000c"
}

variable "fsp_provider_api_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-provider-api-svc@sha256:389b87eccbcb79ef366c9a4a84c8ef27497fb761c8930575a74c77c35f1ba30c"
}

variable "fsp_requirement_mgmt_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-requirement-mgmt-svc@sha256:bc269cbb2efc20f0419782f42992fcc006a7860c254e5edab126fa8c7c6fb6a0"
}

variable "fsp_test_generation_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-test-generation-svc@sha256:8ac8f743518e98b8dfc7e918ab32ec8c53dc194549e104740007bc61a9a42389"
}

variable "fsp_mcp_generation_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-mcp-generation-svc:7cf9dcd24693c82b65e467d7f06bfe6158dfb0d3"
}

variable "fsp_gatewayonboarding_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-gatewayonboarding-svc:latest"
}

variable "fsp_compliance_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fq-dashboard-mgmt-svc:e30a7ad04876f61c8fc34d40d81485ce8224c438"
}

# =========================
# Misc / FE
# =========================

variable "forgesphere_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgesphere-fe@sha256:5e7c3bfda8c5d3928977072c365691df117dce5c584a68996b128bd32dc0be1b"
}

variable "forgestudio_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgestudio-fe@sha256:5ce6a9df2005b727dfdfa4b4e377c0b11c6f0981817fd4d3c9999d338f0e57e3"
}

variable "forgehub_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgehub-fe@sha256:4f2a87c0fc2d237ad71c563d5d2f2087bf59cd08335d2023fc450f83686c4a1f"
}

variable "forgeai_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/probestack-ai-gw@sha256:8cf0b7d618f2a165308875b2509ceb8c326d00dc0c68f4bafcf3d3c74b09273a"
}

variable "forgekonnect_fe_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/forgeq-fe@sha256:52fac73b9decf7f3604f4261a0d791e8fedbdd74501e9143ef8a05a3c6f2f494"
}

variable "fsp_kong_wrapper_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-kong-wrapper-svc@sha256:def23d373a347845112011a8fb649a1f72e22e2e1ecb43e29663b4ffd11acd6b"
}

variable "fsp_apigee_wrapper_svc_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-dev-apps/fsp-apigee-wrapper-svc:cbc23442dc7c11378de33ed20255cb262bad8822"
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


