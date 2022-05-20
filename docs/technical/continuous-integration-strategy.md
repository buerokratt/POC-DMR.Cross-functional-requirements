# Continuous Integration Strategy

This document outlines a high level strategy and approach for Continuous Integration pipelines across the whole Bürokratt system.

Continuous Integration (CI) is the practice of merging developer's code to the central (`main`) branch frequently and in doing so "continuously" ensuring that the code "integrates" well with other code. 

It is typical when using CI, that the incoming code (the code being merged) goes through several automated checks before merging, this is the purpose of the CI pipeline.

The code for Bürokratt is written in C# which mandates some of the things that the CI pipeline does.

## Where does CI run?

Each code repository will have a CI pipeline. The pipelines themselves will be the same but they will be published on each repository.

At the time of writing, this includes the following repositories:

- https://github.com/buerokratt/Mock-Classifier
- https://github.com/buerokratt/Mock-Bot
- https://github.com/buerokratt/DMR
- https://github.com/buerokratt/CentOps

## When does CI run?

CI pipelines should run as part of the pull request process when merging features branches to `main`.

CI pipelines will only run in association with a pull request and every update to a pull request after it has been created ("Draft" or "Ready for review"). CI pipelines will not run on every commit (unless it is associated with a pull request).

A PR should have a "succeeded" CI pipeline before code can be merged and the PR can be completed.

## What does CI do?

All CI pipelines will do the following tasks

| Task                 | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| dotnet tool restore  | Uses the `dotnet` CLI to restore tools, specifically Stryker. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-tool-restore |
| dotnet restore       | Uses the `dotnet` CLI to restore the .net packages which the project depends on. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-restore |
| dotnet format        | Uses the `dotnet` CLI to evaluate the the code according to defined style rules for the project and fail if there are violations. See https://github.com/dotnet/format and [code-analysis.md](code-analysis.md). |
| dotnet build         | Uses the `dotnet` CII to build the project. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build |
| dotnet publish       | Uses the `dotnet` CI to publish the project. This makes the files available for packaging. |
| dotnet test          | Uses the `dotnet` CLI to run all tests associated with the project. This include integration and unit tests. This also includes generated code coverage reports. See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-test |
| Upload Code Coverage | Upload the code coverage reports as artefacts for the pipline run and comments on the pull request. |
| Mutation testing     | Runs the mutation testing package as defined in [unit-testing-strategy](unit-testing-strategy.md). This include uploading the mutation testing report as a pipline artefact |
| Build image          | Uses the `docker` CLI to build the image for the project. See https://docs.docker.com/engine/reference/commandline/image_build/ |



