# Terragrunt Error: Fetch correct dependency outputs

This repository contains the code to reproduce a bug (?) in Terragrunt, where the wrong dependency outputs
are fetched if the dependency is outside of the current working directory.

See also the following GitHub issue: https://github.com/gruntwork-io/terragrunt/issues/4123

## Getting Started
This Terragrunt configuration uses a local backend S3 to store TF state files under `_tf_state/`.

The `run.sh` bash script sets the Terragrunt flags required to reproduce this bug.
Note that if you don't enable `TG_USE_PARTIAL_PARSE_CONFIG_CACHE`, the configuration works as expected.

### Steps to Reproduce the bug
1. `./run.sh cloud_development/ apply` -> should work
2. `./run.sh cloud_staging/ apply` -> you get the error
    ```
    15:44:02.876 ERROR  [data_lake_private_link] Error: Unsupported attribute
    15:44:02.877 ERROR  [data_lake_private_link]   on ../cloud_development/data_lake_private_link/terragrunt.hcl line 36:
    15:44:02.877 ERROR  [data_lake_private_link]   36:       from = [dependency.bs_infra_vpc.outputs.content_map.vpc, dependency.bs_infra_data_lake.outputs.content_map.data_lake]
    15:44:02.877 ERROR  [data_lake_private_link] This object does not have an attribute named "data_lake".
    15:44:02.877 WARN   [../cloud_development/data_lake_private_link] Error reading partial config for dependency dev_bs_infra_data_lake_private_link: ../cloud_development/data_lake_private_link/terragrunt.hcl:36,113-123: Unsupported attribute; This object does not have an attribute named "data_lake".
    15:44:02.976 ERROR  [data_lake_private_link] Error: Unsupported attribute
    15:44:02.976 ERROR  [data_lake_private_link]   on ./data_lake_private_link/terragrunt.hcl line 37:
    15:44:02.978 ERROR  [data_lake_private_link]   37:       from = [dependency.bs_infra_data_lake.outputs.content_map.data_lake, dependency.dev_bs_infra_data_lake_private_link.outputs.content_map.data_lake_private_link]
    15:44:02.978 ERROR  [data_lake_private_link] This object does not have an attribute named "data_lake".
    15:44:02.978 ERROR  [data_lake_private_link] Error: Unsupported attribute
    15:44:02.978 ERROR  [data_lake_private_link]   on ./data_lake_private_link/terragrunt.hcl line 37:
    15:44:02.978 ERROR  [data_lake_private_link]   37:       from = [dependency.bs_infra_data_lake.outputs.content_map.data_lake, dependency.dev_bs_infra_data_lake_private_link.outputs.content_map.data_lake_private_link]
    15:44:02.978 ERROR  [data_lake_private_link] This object does not have an attribute named "data_lake_private_link".
    15:44:02.981 ERROR  [data_lake_private_link] Unit ./data_lake_private_link has finished with an error
    ```
3. You can see the incorrectly fetched output in the debug logs by running
    ```
    TG_LOG_LEVEL=debug ./run.sh cloud_staging/ plan 2>&1 | grep -A 5 "Retrieved output"
    ```
    All module outputs are the ones from the `vpc` module. For example, `data_lake_private_link`:
    ```
    15:47:26.870 DEBUG  [../cloud_development/data_lake_private_link] Retrieved output from ../cloud_development/data_lake_private_link/terragrunt.hcl as json: {
    "content": {
        "sensitive": false,
        "type": "string",
        "value": "vpc|staging"
    },
    ```


## Affected Versions
Terragrunt v0.71.1 - v0.83.2

## Testing environment
* OS: Ubuntu 24.04.2 LTS x86_64
* Terraform: v1.9.8
