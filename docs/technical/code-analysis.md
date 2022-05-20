# Code Analysis

Code quality analysis is a method of analysing code and enforcing rules that aim to maintain consistent code style and quality standards in the codebase. 

Read more about code quality analysis on .net here: https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview.

## .editorconfig

.editorconfig files are used to define the rules that are applied to code. You can configure your own or start from a pre-defined template. See https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/configuration-files#editorconfig

For the Burokratt project we use the "All Rules Enabled" `.editorconfig` file that is provided with the [Microsoft.CodeAnalysis.NetAnalyzers v6.* Nuget Package](https://www.nuget.org/packages/Microsoft.CodeAnalysis.NetAnalyzers).

The rule set is used as-is with the following changes (see https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/configuration-options#severity-level for details on severity options):

- `dotnet_analyzer_diagnostic.category-Style.severity` is set to  `warning`. This sets a blanket warning severity to all style rules.
- `dotnet_analyzer_diagnostic.category-Naming.severity` is set to `warning`. This sets a blanket warning severity to all style rules.
- `dotnet_diagnostic.IDE0008.severity` is set to `none`. This allows use of the `var` keyword. See https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/style-rules/ide0007-ide0008
- `dotnet_diagnostic.CA1014.severity` is set to `none`. This disabled the requirement for code to be CLS Compliant. See https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/quality-rules/ca1014

## Project Configuration

The objective for Burokratt is that the project build fails if any rules are violated. This will affect local project builds but will also cause the CI pipeline to fail, which prevents code with violations from merging to the `main` branch.

To enable this, the following project settings have been defined:

- The [Microsoft.CodeAnalysis.NetAnalyzers Nuget Package](https://www.nuget.org/packages/Microsoft.CodeAnalysis.NetAnalyzers). is installed on all projects (including test projects)
- `EnableNETAnalyzers` is set to `true`. This enabled the .NET compiler platform to analyse code. See https://docs.microsoft.com/en-us/visualstudio/code-quality/install-net-analyzers?view=vs-2022
- `AnalysisLevel` is set to `latest-All`. The ensure that the latest code analysis rules are used as the .NET SDK is updated. See https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview#latest-updates and https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview#enable-additional-rules
- `EnforceCodeStyleInBuild` is set to `true`. This ensures that analysis is undertaken whenever a project builds. See https://docs.microsoft.com/en-us/dotnet/core/project-sdk/msbuild-props#enforcecodestyleinbuild
- `TreatWarningsAsErrors` is set to `true`. This ensures that rule violations with severity of warning are treated as errors and cause the build to break. See https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings#treatwarningsaserrors

## Steps to apply Code Analysis

Repeat for all projects in solution (including test projects)
1. Copy the `.editorconfig` file from https://github.com/buerokratt/DMR/blob/main/src/Dmr.Api/.editorconfig
2. Add `.editorconfig` from step 1 to root of project 
3. Add the following settings to the `*.csproj` file within the first `<PropertyGroup>`
```
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisLevel>latest</AnalysisLevel>
<EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
<TreatWarningsAsErrors>true</TreatWarningsAsErrors>
```
4. Add the following package to the `*.csproj` within the `<ItemGroup>`
```
<PackageReference Include="Microsoft.CodeAnalysis.NetAnalyzers" Version="6.0.0">
  <PrivateAssets>all</PrivateAssets>
  <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
</PackageReference> 
```
5. Build the solution and address any rule violations
6. Update the CI pipeline so the format action only verifies. It should read: `dotnet format src/*.sln --no-restore --verify-no-changes`