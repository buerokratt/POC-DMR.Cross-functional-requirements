# Continuous Integration Strategy

This document outlines a high level strategy and approach for Continuous Integration pipelines across the whole Bürokratt system.

Continuous Integration (CI) is the practice of merging developer's code to the central (`main`) branch frequently and in doing so "continuously" ensuring that the code "integrates" well with other code. 

It is typicaly when practicing CI, that the incoming code (the code being merged) goes through several automated checks before merging, this is the purpose of the CI pipeline.

The code for Bürokratt  is written in C# which mandates some of the things that the CI pipeline does.

## When does CI run?

CI pipelines should run as part of the PR process when merging features branches to `main`. A PR should have a "green" CI pipeline before code can be merged and the PR can be completed, this means that all automated checks in the CI pipeline must pass.

## What does CI do?

All CI pipelines will do the following tasks

| Task             | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| dotnet format    | Uses the `dotnet` CLI to format the code according to defined style rules for the project. See https://github.com/dotnet/format |
| dotnet restore   | Uses the `dotnet` CLI to restore the .net packages which the project depends on. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-restore |
| dotnet build     | Uses the `dotnet` CII to build the project. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build |
| dotnet test      | Uses the `dotnet` CLI to run all tests associated with the project. This include integration and unit tests. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-test |
| Mutation testing | Runs the mutation testing package as defined in [unit-testing-strategy](unit-testing-strategy.md). |
| dotnet publish   | Uses the `dotnet` CI to publish the project. This makes the files available for packaging. |
| Build image      | Uses the `docker` CLI to build the image for the project     |
| Sign image       | Signs the docker image for the project                       |
| Upload image     | Uploads the Docker image to the GitHub container registry    |

**TO DO: It feels like the publish and image preparation steps are more CD than CI. Need to discuss**

