# GitHub Actions CI/CD Pipeline

This directory contains GitHub Actions workflows for automated deployment and testing of the Ikerian AWS Data Pipeline.

## 🚀 Workflows

### 1. **deploy.yml** - Main Deployment Pipeline
- **Triggers**: 
  - Push to `develop` branch (development deployment)
  - Pull request merged to `main` branch (production deployment)
- **Features**:
  - Automated Terraform deployment
  - Environment-specific configurations
  - Security scanning
  - Deployment verification
  - Automatic release creation for production

### 2. **security.yml** - Security Scanning
- **Triggers**: 
  - Daily schedule (2 AM UTC)
  - Push to `develop` branch
  - Pull requests to `main` branch
- **Features**:
  - TFSec security scanning
  - Checkov security analysis
  - Trivy vulnerability scanning
  - SARIF report upload

### 3. **test.yml** - Infrastructure Testing
- **Triggers**: Pull requests to `main` branch only
- **Features**:
  - Terraform validation
  - Lambda function syntax checking
  - Infrastructure configuration testing
  - Makefile validation

## 🔧 Setup Requirements

### GitHub Secrets
Configure the following secrets in your GitHub repository:

#### Development Environment
- `AWS_ACCESS_KEY_ID` - AWS access key for development
- `AWS_SECRET_ACCESS_KEY` - AWS secret key for development

#### Production Environment
- `AWS_ACCESS_KEY_ID_PROD` - AWS access key for production
- `AWS_SECRET_ACCESS_KEY_PROD` - AWS secret key for production

### GitHub Environments
Create the following environments in your GitHub repository:

1. **development**
   - Protection rules: None (for automated deployment)
   - Environment variables: None (uses secrets)

2. **production**
   - Protection rules: Required reviewers (recommended)
   - Environment variables: None (uses secrets)

## 📋 Deployment Process

### Development Deployment
1. Push code to `develop` branch
2. GitHub Actions automatically:
   - Validates Terraform configuration
   - Deploys to development environment
   - Verifies deployment success
   - Notifies on completion

### Production Deployment
1. Create a pull request to `main` branch
2. GitHub Actions runs security scans and tests
3. After PR is merged to `main` branch:
   - Validates Terraform configuration
   - Deploys to production environment
   - Verifies deployment success
   - Creates a GitHub release
   - Notifies on completion

## 🔒 Security Features

- **TFSec**: Scans Terraform code for security issues
- **Checkov**: Static analysis for infrastructure security
- **Trivy**: Vulnerability scanning
- **SARIF Reports**: Security findings uploaded to GitHub Security tab
- **Environment Protection**: Production deployments can require approval

## 📊 Monitoring

### Deployment Verification
Each deployment includes automatic verification:
- S3 bucket existence check
- Lambda function availability check
- IAM role validation
- CloudWatch log group verification

### Notifications
- Success/failure notifications in workflow logs
- GitHub release creation for production deployments
- Security scan results in GitHub Security tab

## 🛠️ Local Development

### Prerequisites
- Terraform >= 1.11.4
- AWS CLI configured
- Python 3.9+
- Make

### Commands
```bash
# Initialize and validate
make init
make validate

# Plan and apply (development)
terraform workspace select dev
make plan
make apply

# Check deployment status
make status
```

## 🔄 Workflow Triggers

### Automatic Triggers
- **Push to `develop`**: Deploys to development
- **Pull Request merged to `main`**: Deploys to production
- **Pull Request to `main`**: Runs tests and security scans
- **Daily Schedule**: Runs security scans

### Manual Triggers
- Workflows can be triggered manually from the GitHub Actions tab
- Useful for emergency deployments or testing

## 📝 Best Practices

1. **Branch Protection**: Enable branch protection rules for `main`
2. **Required Reviews**: Require pull request reviews for production
3. **Environment Protection**: Use GitHub environments for production
4. **Secret Management**: Use GitHub secrets for sensitive data
5. **Monitoring**: Monitor deployment logs and security scan results
6. **Rollback**: Keep previous Terraform plans for rollback capability

## 🚨 Troubleshooting

### Common Issues
1. **AWS Credentials**: Ensure secrets are properly configured
2. **Terraform State**: Check for state lock issues
3. **Resource Conflicts**: Verify no existing resources conflict
4. **Permissions**: Ensure AWS IAM permissions are sufficient

### Debug Steps
1. Check workflow logs in GitHub Actions
2. Verify AWS credentials and permissions
3. Test Terraform commands locally
4. Check for resource naming conflicts

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/)
- [Checkov Documentation](https://www.checkov.io/)
