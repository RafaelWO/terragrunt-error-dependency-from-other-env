locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region = "eu-west-1"

  # Extract the variables we need for easy access
  environment = local.environment_vars.locals.environment
}

# Configure Terragrunt to automatically store tfstate files locally
remote_state {
  backend = "local"
  config = {
    path         = "${get_repo_root()}/_tf_state/${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child `terragrunt.hcl` config via the include block.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.environment_vars.inputs,
)
