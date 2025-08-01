# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all components and environments, such as how
# to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common for the component across all
# environments.
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/data_lake_private_link.hcl"
  expose = true
}


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Additional dependencies for this environment
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
dependency "bs_infra_data_lake" {
  config_path = "${get_repo_root()}/cloud_development/data_lake"
}
dependency "dev_bs_infra_data_lake_private_link" {
  config_path = "${get_repo_root()}/cloud_development/data_lake_private_link"
}


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Override parameters for this environment
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
inputs = {
  content_map = {
    data_lake_private_link = {
      from = [dependency.bs_infra_data_lake.outputs.content_map.data_lake, dependency.dev_bs_infra_data_lake_private_link.outputs.content_map.data_lake_private_link]
      txt = include.envcommon.locals.environment_vars.locals.environment
    }
  }
}
