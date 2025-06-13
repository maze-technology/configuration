# Configuration

Manage GitHub configuration and other public resources using OpenTofu

[![Continuous Integration (CI)](https://github.com/maze-technology/configuration/actions/workflows/opentofu.yaml/badge.svg?branch=main)](https://github.com/maze-technology/configuration/actions/workflows/opentofu.yaml)

## Quality

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)

[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Technical Debt](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=sqale_index)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)

[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=coverage)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=bugs)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=maze-technology_configuration&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=maze-technology_configuration)

## Deployment Instructions

### Step 1: Initialization

1. You need OpenTofu 1.9.0 installed

### Step 2: Create a GitHub App

1. Go to your GitHub organization settings and navigate to "Developer settings" > "GitHub Apps".
2. Click "New GitHub App" and fill in the required details:
   - **Repository permissions**: Set the following permissions:
     - **Administration**: Read & write
     - **Contents**: Read & write
     - **Metadata**: Read-only
     - **Pull requests**: Read & write
     - **Secrets**: Read & write
     - **Variables**: Read & write
   - **Organization permissions**: Set the following permissions:
     - **Administration**: Read & write
     - **Members**: Read & write
3. Click "Create GitHub App".
4. Generate a private key for the GitHub App and download it (and store it somewhere safe).
5. Note the **App ID** and **Installation ID** for later use.

### Step 3: Initialize the Bootstrap Folder

1. Open a terminal in the repository root folder and navigate to the `bootstrap/` directory:
   ```sh
   cd ./bootstrap/
   ```
2. Run the following command to initialize OpenTofu:
   ```sh
   tofu init
   ```
3. Run the following command to apply the OpenTofu scripts, replace the values with yours:
   ```sh
   AWS_REGION="YOUR_COMPANY_AWS_REGION" AWS_PROFILE="YOUR_COMPANY_AWS_PROFILE" tofu apply \
   -var="aws_account_id=YOUR_COMPANY_AWS_ACCOUNT_ID" \
   -var="github_username=YOUR_COMPANY_GITHUB_USERNAME" \
   -var="github_repository=YOUR_COMPANY_GITHUB_CONFIGURATION_REPOSITORY" \
   -var='default_tags={"CompanyIdentifier":"YOUR_COMPANY_IDENTIFIER"}'
   ```
4. Note the output keys=values for later use

### Step 4: Configure the GitHub Repository

1. Go to your GitHub repository settings.
2. Navigate to the "Secrets and variables" section and add the following:

   **Secrets:**

   - `GH_ACTIONS_ROLE_ARN` (value from `gh_actions_role_arn` output in Step 3)
   - `GH_APP_ID` (GitHub App ID from Step 2)
   - `GH_APP_INSTALLATION_ID` (GitHub App Installation ID from Step 2)
   - `GH_APP_PRIVATE_KEY` (Contents of the private key file downloaded in Step 2)
   - `DOCKER_PASSWORD` (Your Docker Hub password)
   - `SONAR_TOKEN` (Your SonarCloud API token)

   **Variables:**

   - `AWS_REGION` (AWS Region from Step 3)
   - `S3_BUCKET_NAME` (value from `s3_bucket_name` output in Step 3)
   - `DYNAMODB_TABLE_NAME` (value from `dynamodb_table_name` output in Step 3)
   - `KMS_KEY_ALIAS` (value from `kms_key_alias` output in Step 3)
   - `DOCKER_USERNAME` (Your Docker Hub username)
   - `DOCKER_ORG_NAMESPACE` (Your Docker Hub organization namespace)

3. You may need to import the Github configuration repository in the infrastructure/ state:
   ```sh
   AWS_REGION="YOUR_COMPANY_AWS_REGION" AWS_PROFILE="YOUR_COMPANY_AWS_PROFILE" tofu import \
   -var="github_owner=YOUR_COMPANY_GITHUB_USERNAME" \
   -var="github_app_id=YOUR_COMPANY_GITHUB_APP_ID" \
   -var="github_app_installation_id=YOUR_COMPANY_GITHUB_APP_INSTALLATION_ID" \
   -var="github_app_private_key_path=YOUR_COMPANY_GITHUB_APP_PRIVATE_KEY_PATH" \
   -var="docker_username=YOUR_COMPANY_DOCKER_USERNAME" \
   -var="docker_password=YOUR_COMPANY_DOCKER_PASSWORD" 'github_repository.repo["configuration"]' YOUR_COMPANY_GITHUB_CONFIGURATION_REPOSITORY
   ```
