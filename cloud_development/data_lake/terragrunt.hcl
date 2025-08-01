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
  path   = "${dirname(find_in_parent_folders())}/_envcommon/data_lake.hcl"
  expose = true
}

# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Override parameters for this environment
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
inputs = {
  content_map = {
    data_lake = {
      from = []
      txt = include.envcommon.locals.environment_vars.locals.environment
    }
  }
}
