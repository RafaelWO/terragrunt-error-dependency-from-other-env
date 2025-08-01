# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration.
locals {
  environment = "dev"
}

# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration.
inputs = {
  environment = local.environment
}
