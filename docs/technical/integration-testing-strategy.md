# Integration Testing Strategy

This document outlines the integration testing strategy for all Bürokratt components.

## What is Integration Testing?

Integration tests are tests that ensure that one or more components of a system work correctly in their integrated form. For the purposes of Bürokratt, "integrated form" can be understood to be when they are deployed to Azure and configured correctly.

Integration tests assure that components integrate with each other as expected and test "paths" through the overall system via integrated components.

Integration tests can test very short, specific paths or much broader end-to-end paths.

Integration tests can test both expected outcomes and also test for edge scenarios such as error cases.

In the wider technical community, this kind of testing can also be known as "System Testing". The term "System Testing" generally leans towards testing only the whole system, not sub-components within it. System testing can also be called "end to end" testing.

The term "smoke testing" can also be used which is generally referred to as a type of system test which just asserts that the expected path through the system works correctly.

For the purposes of Bürokratt and this strategy, all of the above terms can be collectively understood as "integration tests".

Integration tests are not to be confused with "unit tests" which make assertions of specific code modules and therefore operate at the code level, before the system component has been deployed and integrated. By the time a component is exposed to integration tests, it should have already passed all of its unit tests.

## Tests and Assertions

This section will outline the integration tests that will be created and what assertions they will make. This only outlines the initial "happy path" tests that are required to build assurances that the integrated system is operating correctly.

In passing these tests, all system components (Mock Bot, DMR, Mock Classifier and CentOps) will have been exercised. Additional tests which check edge cases and error cases can be added later.

### Classify a message

This test asserts that when DMR receives an unclassified message which is correctly formed, it is able to classify it and reply to the calling participant with the classification. This is steps 1-4 from [Milestones.md](https://github.com/buerokratt/Project-Documentation-Management/blob/main/Milestones.md) and represents milestone 1.

Input: Test requests that mock bot generates an unclassified message with all appropriate headers and submits it to DMR.

Expected output: DMR calls back to the mock bot with a classification. Assert that the classification is what was expected for the message contents.

### Bot-to-bot

This test asserts that a bot can route a classified message to another bot via DMR. This represents steps 6 and 7 from [Milestones.md](https://github.com/buerokratt/Project-Documentation-Management/blob/main/Milestones.md) and milestone 2

Input: Test requests that mock bot generates a classified message with all appropriate headers and submits it to DMR.

Expected output: DMR forwards the message to the correct mock bot. Test asserts that the message was received and is in the expected format.

## How to make assertions on HTTP calls

The architecture of the Bürokratt system operates on a series of chained HTTP requests and the final step of any interaction is for a mock bot to receive a HTTP request from DMR.

In order to assert that these HTTP requests are being received, we can use some of the existing endpoints that are included in the mock bot to create chats and post messages to a chat (thereby sending it to DMR).

There may be some minor extensions required to mock bot to ensure that when DMR responds back to the bot, the message is added to the Chat (currently it is disposed). This will enable us to simply get the chat and inspect the contents which should contain both the initial message out to DMR and the classified response back from DMR.

## Platform and Tooling

## Pipelines

