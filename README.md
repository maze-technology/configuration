# Maze Technologies GitHub Configuration

Configure all Maze Technologies GitHub repositories using OpenTofu

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
   - **Organization permissions**: Set the following permissions:
     - **Administration**: Read & write
     - **Members**: Read & write
3. Click "Create GitHub App".
4. Generate a private key for the GitHub App and download it.
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
   AWS_REGION="YOUR_COMPANY_AWS_REGION" AWS_PROFILE="YOUR_COMPANY_AWS_PROFILE" tofu apply -var="aws_account_id=YOUR_COMPANY_AWS_ACCOUNT_ID" -var="github_username=YOUR_COMPANY_GITHUB_USERNAME" -var="github_repository=YOUR_COMPANY_GITHUB_CONFIGURATION_REPOSITORY" -var='default_tags={"CompanyIdentifier":"YOUR_COMPANY_IDENTIFIER"}'
   ```
4. Note the output keys=values for later use

### Step 4: Configure the GitHub Repository
1. Go to your GitHub repository settings.
2. Navigate to the "Secrets and variables" section and add the following:

   **Secrets:**
   - `GH_ACTIONS_ROLE_ARN` (value from `gh_actions_role_arn` output)
   - `GH_APP_ID` (GitHub App ID from Step 2)
   - `GH_APP_INSTALLATION_ID` (GitHub App Installation ID from Step 2)
   - `GH_APP_PRIVATE_KEY` (Contents of the private key file downloaded in Step 2)

   **Variables:**
   - `AWS_REGION`
   - `S3_BUCKET_NAME` (value from `s3_bucket_name` output)
   - `DYNAMODB_TABLE_NAME` (value from `dynamodb_table_name` output)
   - `KMS_KEY_ALIAS` (value from `kms_key_alias` output)
