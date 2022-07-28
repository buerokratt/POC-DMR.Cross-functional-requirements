# Continuous Deployment Strategy for Infrastructure

This document outlines the strategy for Continuous Deployment for Infrastructure as Code part of the Bürokratt system.

## GitHub workflows

There are three main parts to CD deployment for this project:

### 1. One-time Setup

Calls a [bash script](https://github.com/buerokratt/Infrastructure/blob/main/scripts/setup-project-prereqs.sh) which creates a `Storage Account` to store terraform state

This workflow has to be run once per project.

### 2. Infrastructure workflows

Sets up the infrastructure for the project using Terraform.

This is split into two workflows with different triggers
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

Both of these workflows call a shared, variablised [reusable terraform deployment](https://github.com/buerokratt/Infrastructure/blob/main/.github/workflows/reusable-terraform-deployment.yml) workflow in order to achieve consistent deployments across all environments.

#### 2.1 PR Environments

Environments related to a PRs in the infrastructure repository are deployed with the `pr<pr_number>` environment naming convention.  This temporary environment is designed to allow developers to test their changes independently without disrupting `dev` and `prod` environments.

#### 2.2 PR Cleanup

Once the changes in PR branch are merged into `main` branch, the [PR Teardown workflow](https://github.com/buerokratt/Infrastructure/blob/main/.github/workflows/cd-infrastructure-release.yml) triggers automatically to cleanup environments that are no longer required.
