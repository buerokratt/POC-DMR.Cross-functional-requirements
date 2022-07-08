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


## What does CD do?

## CD Pipeline Breakdown