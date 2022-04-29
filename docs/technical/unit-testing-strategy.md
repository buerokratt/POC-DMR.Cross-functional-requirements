# Unit Testing Strategy

This document outlines the overall unit testing strategy for all components in the Bürokratt system.

[Unit testing](https://en.wikipedia.org/wiki/Unit_testing) is the process of testing specific units of code to ensure that they produce reliable and consistent outputs.

Custom code should be structured into granular units so that logic is isolated and highly testable. This means that as much as possible, code should confirm to the [single responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle).

## Test Framework

We will use [xUnit](https://docs.microsoft.com/en-us/dotnet/core/testing/unit-testing-with-dotnet-test) for .net unit testing. This is the standard and most popular library for testing modern .net code.

## Mocking

Unit tests often require external services and dependencies to be [faked, mocked or stubbed](https://docs.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices#lets-speak-the-same-language).

Where possible, you should look to use the concrete implementation of a service, but where that is not practical we will use the [Moq](https://github.com/moq/moq) framework for mocking in unit tests.

## Code Coverage and Mutation Testing

We are targeting 80% [code coverage](https://en.wikipedia.org/wiki/Code_coverage) for all units, this means that when unit tests are executed, at least 80% of the code should be exercised. This mandates that inputs and different paths through the code must be considered. 

We will use [Coverlet](https://github.com/coverlet-coverage/coverlet) for code coverage data collection and report generation. See [Use code coverage for unit testing](https://docs.microsoft.com/en-us/dotnet/core/testing/unit-testing-code-coverage?tabs=windows) for details of how to configure code coverage for .net.

We will use [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing) tools to ensure that tests are well written and meaningful. Specifically we will use [Stryker.NET](https://stryker-mutator.io/docs/stryker-net/Introduction) to run mutation testing.

## When do we test?

Unit tests can and should be run by developers in their IDE as they are writing code.

Unit tests and associated mutation testing will be automatically run as part of the [continuous integration (CI)](https://en.wikipedia.org/wiki/Continuous_integration) pipeline in GitHub actions. 

The CI pipeline will require all tests to pass with >80% code coverage in order for the pipline to be "green".

A green pipeline is a requirements before a PR can be merged into the `main` branch for the repository.



