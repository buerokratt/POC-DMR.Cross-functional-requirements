# ADR: Versioning strategy for containers and code packages

## Context

Currently, all containers and code packages are versioned with the full git commit SHA.  Whilst this tells us exactly which commit a package has been built from, it doesn't make the version very accessible to consumers of the package without looking into it further.

In some places, we have implemented a crude semantic version style where the version is 1.0.<github_run_number>. However, this does not allow us to easily bump major/minor versions or highlight breaking changes.

## Decision

1. Use the [GitVersion GitHub Action](https://github.com/marketplace/actions/gittools) to implement semantic versions across all containers and applications: https://gitversion.net/docs/learn/intro-to-semver
2. Packages from `main` branch are to have a full semantic version like this: `1.2.3`
3. Packages from non-`main` branches are to have a full semantic version like this: `1.2.3-pr17.12`
   * `pr17` - denoting that the package is an output of a (hypothetical) PR #17 
   * `.12` - number of pushes in made to the branch/PR
   * The above values are default out-of-the-box functionality of the GitVersion tool mentioned above
4. For consistency, the docker image tags should also use the same versioning strategy
5. Any package with `-suffix` after the version number is to be treated as 'prerelease' by the NuGet package manager

When the GitVersion tool is configured in the "Mainline" development mode, it will automatically bump the version number on every merge into `main` branch.
When we need a major or minor version number bump: https://gitversion.net/docs/reference/version-increments#manually-incrementing-the-version

### Alternatives

These alternative versioning styles were considered
| Versioning strategy | Comments |
|---------------------|----------|
| `1.2.3-f6377258` | SemVer versioning with a short SHA suffix. <br> 1. NuGet treats versions with "-suffix" on the end as prerelease versions so this won't be appropriate for NuGet packages. <br> 2. Since our decision is to use "Mainline" development mode, we will not be able to replace a version with another binary, any commits will always generate a new version number, thus making short SHAs somewhat redundant. |
| `1.0.<github_run_number>` | Another flavour of SemVer versioning. However, this requires a lot of fiddling and work to make it work in the PR and `main` branch scenarios. Using GitVersion takes care of this. |

## Status

| Asset    | Implemented |
|----------|-------------|
| Buerokratt.Common library | `IN PROGRESS` |
| CentOps docker container | ❌ |
| DMR docker container | ❌ |
| MockClassifier docker container | ❌ |
| MockBot docker container | ❌ |

## Consequences

The consequences of not implement this versioning strategy would mean:
* It would become difficult to workout whether a package reference update is a newer or older version.
* It would make creating release packages more difficult and increase the barrier to entry for developers trying to consume any of our packages
