# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for the module. The common variables for each environment are defined here. This configuration will be merged into
# the environment configuration via an include block.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  source = "${local.base_source_url}/_modules/my_file//."
}


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# LOCALS
# Locals are named constants that are reusable within the configuration.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
locals {
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will be used to construct the terraform block
  # in the child terragrunt configurations.
  base_source_url = "${get_repo_root()}"

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# DEPENDENCIES
# These are dependencies to other terragrunt modules. Each dependency block exports the outputs of the target module as block attributes you can reference
# throughout the configuration.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all environments.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
inputs = {
  content_map = {
      vpc = {
        from = []
        txt = "envcommon"
      }
    }
}
