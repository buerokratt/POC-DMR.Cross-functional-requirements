# Continuous Deployment Strategy

This document outlines a high level strategy and approach for Continuous Deployment pipelines across the whole Bürokratt system.

Continuous Deployment (CD) is the practice of automatcially releasing developers chnages from the (`main`) branch frequently and in doing so "continuously" ensuring that the code "integrates" well with other code. 

By combining Continuous Integration and infrastructure as code (IaC), we're able to achieve identical deployments with the confidence to be able to deploy to production at any time. Continuous Deployment, allows us to automate the entire process from code commit to production if CI/CD tests and security checks are successful.

## Where does CD run?

Each code repository will have a CI pipeline which in turn calls a CD pipeline which sits inside the Infrastructure Repository. The pipelines themselves will be the same but they will be published on each repository.

At the time of writing, this includes the following repositories:

- [Mock-Bot](https://github.com/buerokratt/Mock-Bot/tree/main/.github/workflows/ci-build-publish-main.yml)
- [DMR](https://github.com/buerokratt/DMR/blob/main/.github/workflows/ci-build-publish-main.yml)
- [CentOps](https://github.com/buerokratt/CentOps/blob/main/.github/workflows/build-publish-main.yml)

The main CD pipelines sit in the [Infrastructure Repo](https://github.com/buerokratt/Infrastructure/tree/main/.github/workflows)

## When does CD run?

For the 3 code based repositories the CD pipeline runs when code is pushed to `main`

This initates the creation of docker containers which are signed and put onto GCR (GitHub Container Registry)

The pipeline inside the Infrastructure Repo is trigger using a GitHub CLI step 

`gh workflow run $cd_workflow_dispatch_file_name -f app_name=$app_name -f image_tag=${GITHUB_SHA} --repo $infrastructure_repo_path --ref main`


## CD Pipeline Breakdown

There are three main parts to CD deployment for this project:

1. One-time Setup

Calls a [bash script](https://github.com/buerokratt/Infrastructure/blob/main/scripts/setup-project-prereqs.sh) which creates a `Key Vault` to store terraform state

This pipeline has to be run once per project when the code is first cloned 

2. Infrastructure

Sets up the underlying Azure Architechture using Terraform

This is split into two pipelines with different triggers
  * [PR](https://github.com/buerokratt/Infrastructure/blob/main/.github/workflows/cd-infrastructure-pr.yml)
    - Triggered by:
        - `workflow_dispatch` manually running the workflow
        - Opening/commiting to/closing a `pull_request` on `main` specifically any folders that contain either infrastucture terraform or relevant workflows
  * [Release](https://github.com/buerokratt/Infrastructure/blob/main/.github/workflows/cd-infrastructure-release.yml)
    - Triggered by:
        - `workflow_dispatch` manually running the workflow
        - `push` to `main` specifically any folders that contain either infrastucture terraform or relevant workflows
    - Has branch protection rules (set in [GH Enironments](https://github.com/buerokratt/Infrastructure/settings/environments/525828854/edit))
        * `Dev_deployment`
        * `Prod_deployment`
            * Requires successful execution of `Dev_deployment`

Both of these pipelines call a subsequent [reusable terraform deployment](https://github.com/buerokratt/Infrastructure/blob/main/.github/workflows/reusable-terraform-deployment.yml) action

### Action Inputs

| parameter              | value                                       |
|------------------------|---------------------------------------------|
| gh_environment         | GitHub Repository Environment               |
| working_directory_path | Path where code to execute sits             |
| environment_name       | Environment prefix used in Azure resources  |
| environment_postfix    | Environment postfix used in Azure resources |

| secret                    | value                                                            |
|---------------------------|------------------------------------------------------------------|
| azure_ad_client_id        | Azure Active Directory Client Id                                 |
| azure_ad_client_secret    | Azure Active Directory Client Secret                             |
| azure_subscription_id     | Azure Active Directory Subscription Id                           |
| azure_ad_tenant_id        | Azure Active Directory Tenant Id                                 |
| azure_storage_account_key | Azure Blob Storage Account key for the terraform storage account |

| Task               | Description |
|--------------------|-------------|
| Checkout           |             |
| Setup Terraform    |             |
| Terraform Format   |             |
| Terraform Init     |             |
| Terraform Validate |             |
| Terraform Apply    |             |

3. Kubernetes Deployment