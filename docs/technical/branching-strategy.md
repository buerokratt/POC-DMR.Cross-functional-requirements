# Branching Strategy

This document outlines the overall branching strategy for all components repositories in the Bürokratt system.

[Trunk Based Development](https://trunkbaseddevelopment.com/) model is used.


Feature branches should only be merge into main via **pull request** - **PR**

PRs can only be merged into main with **squash merge**

For branching prefexes are used:
- release/*
- feature/*
- hotfix/*

Feature branch name should consist of prefex followed by issue number and issue title in lowercase, concatinated wiht hyphens.

For example:
`feature/4-dmr-setup-cd` is for is feature branch for issue [DMR: Setup CD](https://github.com/buerokratt/DMR/issues/4)

After successful merge into main branch the used branch should be deleted.
# TL;DR
* Short living feature branches
* Feature branch goes back to `main` branch after it passes the CI pipeline and code review.
