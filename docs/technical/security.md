# Security Architecture

The architecture for Buerokratt is almost entirely Kubernetes based.  For the MVP we will be using the Azure Kubernetes Service (AKS).

GitHub will run the CI/CD pipelines via GitHub Actions.

![Development Workflow](./DevelopmentWorkflow.editable.png)

## Development Environment

Whilst the code is still on a developers machine there are numerous opportunities to avoid and resolve security issues which may arise.

### Language Best Practice

Many tools exist which can enforce best practice on the code developed within a project.  These take the form of simple warnings displayed to the developer for common issues with code.  The developer then needs to resolve the issue or add an exception to the codebase.  Exceptions to best practice would be examined in code review and verified before the code is committed.

Many 3rd party tools exist which generate warnings in the developer's IDE for the infractions as they are discovered.

[SonarQube](https://www.sonarqube.org/) is a common source scanning tool and will warn about many features of a project's source code 'health' (dependencies included) and supports a number of languages.

.NET (use by this project at time of writing) has code analysis tools, these should be enabled on all projects.

Other languages have 'linting' tools which should be considered when onboarding a new language for this project.

### Dependency Health

#### .NET Packages

.NET Core references published open source functionality via Nuget Packages.  These packages may have published security issues, Common Vulnerabilities and Exposures (CVE) or GitHub Security Advisory (GHSA) which will require investigation and replacement by the development team to ensure executing code has the best possible security posture.

Tools like GitHub's [Dependabot](https://docs.github.com/en/code-security/dependabot) and [SonarQube](https://www.sonarqube.org/) have the capability to warn developers when these vulnerabilities are discovered.  
Even the .NET command line tool provides a basic view of dependency issues:

```cmd
dotnet list package --vulnerable --include-transitive
```

This [tooling](https://devblogs.microsoft.com/nuget/how-to-scan-nuget-packages-for-security-vulnerabilities/) is very basic however.

At a minimum tooling should be used to warn developers of issues would run in the build pipeline.  Ideally developers are notified as soon as vulnerabilities are discovered.

#### Password scanning

All code repos in the Buerokratt platform are public on GitHub.  This means that secrets should be carefully segregated from code.  

In order to prevent developers committing secrets to public repos the projection should implement password scanning.

This can be done on a Git commit hook and is documented here:

> See the CentOps repo for an example of this setup.  This should be applied to all repos.

## Built Artefacts

This project aims to package all shipping code in Docker Containers, so we need to validate they are free of known vulnerabilities.

### Containers

Docker Containers most commonly use base images which contain various component which themselves may have security vulnerabilities.  Known CVEs may exist for components within these images which may expose vulnerabilities aside from the code and dependencies directly shipped by this project.

Tools exist to scan containers for vulnerabilities.  One such tool is, Container Scan which can be run as part of the CI pipeline.

[Container Scan](https://github.com/marketplace/actions/container-image-scan)

Other container scanning technologies exist if this is found to be unsuitable.

Some consideration should be given to containers which are in production when vulnerabilities are discovered.  This may mean rescanning containers on a regular basis and raising alerts if security issues are discovered.

## Kubernetes

### Keep up with released versions of Kubernetes

AKS regularly make available updated versions of Kubernetes.  These contain new features, but most importantly for this document, security patches.

Whilst in operation - these updates will need to be evaluated an applied.

### Don't run containers as root

Best practice to avoid 'Container Escape' is to not run the container from a root user account.

For the purposes of this project - that would mean creating a low privileged user.

```Dockerfile
...
RUN adduser \
  --disabled-password \
  --home /app \
  --gecos '' app \
  && chown -R app /app
USER app
...
```

### Run in a non-default namespace

Kubernetes Namespaces are separate from one another although they can communicate with services in other namespaces.   Namespaces offer a way to partition services and make them easier to manage.  

RBAC can be applied at the namespace level and will give admins more granularity and control over the services deployed to namespaces under their control.

For the purposes of this project - DMR and CentOps should reside in their own namespaces (byk-dmr and byk-centops for instance) .  Hosted bots *could* reside in a shared 'bots' namespace as they may have similar access patters and permissions (unless hosted bots have special security considerations)  

### Specify memory and CPU quotas

In order to prevent containers affecting other pods in the cluster it's often recommended to specify cpu and memory limits.  This can be done in the helm chart.

```yaml
...
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
...
```

The process of determining sensible limits can be a tricky one, however.  K8s will terminate the running pod which has gone beyond it's limits, so these values should be carefully chosen.  In the event of a pod exceeding this values - K8s will recycle the pod, so sensible values are a must.

### Read only containers where possible

```yaml
  containers:
  - name: <container name>
    image: <image>
    securityContext:
      readOnlyRootFilesystem: true
```

> We may need to experiment with this one to ensure .NET containers can be run read only.

## Deployed Infrastructure

At time of writing the Buerokratt project will deploy it's resources to Azure using Terraform.

### Complete Separation Between Development and Production Environments

Each deployed environment should have separate resources from one another.  This goes back as far as the Service Principal used to deploy these environments.  (This project uses Service Principal identities to perform infrastructure and application deployment via Terraform).  

No resources should be shared across environments.  e.g. No resources in the 'Dev' environment should be used in the 'Integration' environment.

### Secret Management

All secrets used within this project should be stored using secure stored with deployment Service Principals (for performing deployments) and Service Administrators.

Secrets pertain to data connection strings, access keys or credentials.

GitHub Secrets and Azure Key Vault both offer this capability and can be selected based on the use case.

### Vlans for Resource Protection

Where possible - we can ensure that traffic remains 'hidden' from the internet by creating Virtual Lans.  This project intends to use Cosmos DB as a datastore for the CentOps Service.  

Communication between AKS and CosmosDB can be performed across a vLAN for best protection for this traffic.

### Mutual TLS

Service to service communication within Kubernetes should be protected with mTLS.  This ensures that traffic within the cluster is encrypted, but both client and service authenticate with one another. (See [Mutual TLS](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS))

### IP Filtering on Public Endpoints

Lock down IPs to specific endpoints which are allowed access to particular APIs.

This project will be exposing 'public' and 'private' endpoints from the same clusters.

We should consider opportunities to only allowing access to private endpoints from particular IP addresses. e.g. The Admin API for CentOps can only be called from the network the CentOps Administrator will access it from.

## Security in Operation

### Communication

* HTTPS Everywhere.
* TLS 1.2 at a bare minimum.
* Strict CORS policies where applicable.

### Versioning

Developed Components should identify the version of the code they represent.  This allows participants in the Beurokratt system to gate interaction to other components based on their version.  On API endpoints this might be a simple X-Byk-Version header that ties that component to a particular build.

### Service Telemetry and Monitoring

Successful and unsuccessful API access is something which should be monitored closely.  Unauthenticated or poorly formatted requests are a signal that malicious users are attempting to access and possibly exploit the system.

Metrics to capture:

* Logins (Unsuccessful and Successful).
* Resource access (Unsuccessful and Successful).
* Exceptions and failures.
* Service startup and restart.

Audit Access:

* Admin APIs
* Public APIs

Anomalous usage patters should create alerts for the attention of service owners.

### Authentication and Authorisation

[TBD] (This is still being worked out)