# Integration Testing Strategy

This document outlines the integration testing strategy for all Bürokratt components.

## What is Integration Testing

Integration tests are tests that ensure that one or more components of a system work correctly in their integrated form. For the purposes of Bürokratt, "integrated form" can be understood to be when they are deployed to Azure and configured correctly.

Integration tests assure that components integrate with each other as expected and test "paths" through the overall system via integrated components.

Integration tests can test very short, specific paths or much broader end-to-end paths.

Integration tests can test both expected outcomes and also test for edge scenarios such as error cases.

In the wider technical community, this kind of testing can also be known as "System Testing". The term "System Testing" generally leans towards testing only the whole system, not sub-components within it. System testing can also be called "end to end" testing.

The term "smoke testing" can also be used which is generally referred to as a type of system test which just asserts that the expected path through the system works correctly.

For the purposes of Bürokratt and this strategy, all of the above terms can be collectively understood as "integration tests".

Integration tests are not to be confused with "unit tests" which make assertions of specific code modules and therefore operate at the code level, before the system component has been deployed and integrated. By the time a component is exposed to integration tests, it should have already passed all of its unit tests.

