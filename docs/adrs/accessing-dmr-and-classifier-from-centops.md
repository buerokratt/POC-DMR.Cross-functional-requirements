# Architectural Decision Record For Non-Chatbot Participants

## Issue

Non-chatbot Participants (Classifier and DMR) can have multiple instances in CentOps.  When dependent participants call CentOps to determine the endpoints for these special participants if several Dmr or Classifiers are returned by the CentOps Api.

* CentOps doesn't currently have a way to filter Participants by type.
* CentOps doesn't currently have a way to return the 'best' Dmr or Classifier based on properties of the caller.

## Decision

Implement an API which allows for filtering by Participant type:

```url
/public/participants?type=Dmr
```

The caller simply selects a DMR or Classifier from the list of participants of those types.  To avoid sending unused data on the wire an additional filter 'count' could be implemented.
e.g.:

```url
GET /public/participants?type=Classifier&count=1
```

Clients of this Api will be able to select a single Dmr or Classifier to interact with.

In order to handle Classifiers or DMRs being taken offline clients will need to periodically re-query this endpoint to get the latest 'Active' participants.

### Alternatives

* Allow for one of each special participant type for each Institution.

* Implement a CentOps Api which selects a Dmr or Classifier based on the Id/Name of the requester.

```url
/public/dmrs

/public/classifiers
```
