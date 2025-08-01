#!/usr/bin/env bash
set -e

terragrunt --version
echo "Directory: $1, action: $2"
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
echo "Deleted .terragrunt-cache directories"

export TERRAGRUNT_WORKING_DIR=$1
export TERRAGRUNT_USE_PARTIAL_PARSE_CONFIG_CACHE=true   # This flag seems to not be working in newer versions of Terragrunt
                                                        # See also: https://github.com/gruntwork-io/terragrunt/issues/4596
export TERRAGRUNT_NON_INTERACTIVE=true
#export TERRAGRUNT_LOG_LEVEL=debug

# New flag names for Terragrunt v0.73.0 and later
export TG_WORKING_DIR=$1
export TG_USE_PARTIAL_PARSE_CONFIG_CACHE=true
export TG_NON_INTERACTIVE=true
#export TG_LOG_LEVEL=debug

shift

eval "terragrunt run-all $@"
