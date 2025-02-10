# Maze Technologies Github Configuration

Configure all Maze Technologies Github repositories using OpenTofu

## Deployment Instructions

### Step 1: Initialization
1. You need OpenTofu 1.9.0 installed

### Step 2: Initialize the Bootstrap Folder

1. Open a terminal in the repository root folder and navigate to the `bootstrap/` directory:
   ```sh
   cd ./bootstrap/
   ```
2. Run the following command to initialize OpenTofu with the backend configuration:
   ```sh
   tofu init
   ```
3. Run the following command to apply the OpenTofu scripts, replace the values with yours:
   ```sh
   AWS_REGION="YOUR_AWS_REGION" AWS_PROFILE="YOUR_AWS_PROFILE" tofu apply -var="aws_account_id=YOUR_AWS_ACCOUNT_ID" -var="github_username=YOUR_GITHUB_USERNAME" -var="github_repo=YOUR_GITHUB_REPO" -var='default_tags={"CompanyIdentifier":"YOUR_COMPANY_IDENTIFIER"}'
   ```
4. Note the output keys=values for later use

### Step 3: Configure the GitHub Repository

1. Go to your GitHub repository settings.
2. Navigate to the "Secrets and variables" section and add the following:

   **Secrets:**
   - `AWS_ACCOUNT_ID`
   - `MAZE_GITHUB_ACTIONS_ROLE_ARN` (value from `maze_github_actions_role_arn` output)

   **Variables:**
   - `AWS_REGION`
   - `S3_BUCKET_NAME` (value from `s3_bucket_name` output)
   - `DYNAMODB_TABLE_NAME` (value from `dynamodb_table_name` output)
   - `KMS_KEY_ALIAS` (value from `kms_key_alias` output)
   - `MAZE_GITHUB_OWNER` (GitHub organization name)

### Step 4: Deploy OpenTofu Configuration

The GitHub Actions workflow (`opentofu.yaml`) will automatically run on pushes or pull requests to the `main` branch. This workflow will:
- Checkout the repository.
- Configure AWS credentials using OIDC.
- Install OpenTofu.
- Initialize OpenTofu with the backend configuration.
- Plan and apply OpenTofu changes in the `infrastructure/` folder.

If it's a pull request, the workflow will comment on the PR with the output of the `tofu plan` command.
