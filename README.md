# Ikerian AWS Data Pipeline

A production-ready, end-to-end AWS data pipeline for processing retinal imaging data with automated infrastructure management using Terraform.

## 🚀 Quick Start

```bash
# Clone and navigate
git clone <repository-url>
cd ikerian

# Initialize and deploy
make init
make plan
make apply
```

## 📋 Overview

This project implements a serverless data pipeline that:
- **Ingests** JSON data from S3 raw bucket
- **Processes** data using Lambda with comprehensive validation
- **Stores** processed data in S3 processed bucket
- **Monitors** operations via CloudWatch logs
- **Automates** infrastructure with Terraform

## 🏗️ Architecture

```
S3 Raw Bucket → Lambda Function → S3 Processed Bucket
     ↓              ↓                    ↓
  JSON Upload   Data Validation    Processed Data
  (Trigger)     & Processing      (Structured)
```

## 🛠️ Prerequisites

- **AWS CLI** configured with appropriate permissions
- **Terraform** >= 1.0
- **Python** 3.9+ (for Lambda function)
- **Make** (for simplified commands)

## ⚙️ Configuration

configuration is environment specific e.g. `envs/dev.tfvars`:

```hcl
project_name      = "ikerian"
environment       = "dev"
lambda_timeout    = 300
lambda_memory_size = 128
```

## 🚀 Deployment

### Using Makefile (Recommended)
```bash
make init      # Initialize Terraform
make plan      # Review changes
make apply     # Deploy infrastructure
make destroy   # Clean up resources
```

### Manual Commands
```bash
terraform init
terraform plan -var-file=envs/<work_space>.tfvars -out=tfplan
terraform apply tfplan
```

## 📁 Project Structure

```
ikerian/
├── Makefile        # Build automation
├── README.md       # project readme file
├── envs/           # environment based variables
├── files
│   ├── lambda/     # Python Lambda code
│   └── s3/         # Sample data files
├── main.tf         # Root configuration
├── modules
│   ├── iam/        # IAM roles and policies     
│   ├── lambda/     # Lambda function setup
│   └── s3/         # S3 bucket configuration
├── variables.tf    # Input variables
└── versions.tf     # Provider versions
```

## 🔧 Core Components

### **S3 Buckets**
- **Raw Data**: Stores incoming JSON files
- **Processed Data**: Stores validated and processed data
- **Encryption**: AES256 server-side encryption
- **Versioning**: Enabled for data protection
- **Lifecycle**: Automated storage class transitions

### **Lambda Function**
- **Runtime**: Python 3.9
- **Trigger**: S3 ObjectCreated events
- **Validation**: Comprehensive data validation
- **Processing**: Extracts patient_id and patient_name
- **Error Handling**: Detailed error reporting

### **IAM Security**
- **Least Privilege**: Minimal required permissions
- **Role-Based**: Lambda execution role
- **S3 Access**: Bucket-specific permissions
- **CloudWatch**: Logging permissions

### **Monitoring**
- **CloudWatch Logs**: 14-day retention
- **Structured Logging**: JSON format with context
- **Error Tracking**: Validation failure reporting

## 📊 Data Flow
1. **Upload**: JSON file uploaded to raw bucket
2. **Trigger**: S3 event triggers Lambda function
3. **Validation**: Data validated for structure and content
4. **Processing**: Required fields extracted and cleaned
5. **Storage**: Processed data saved to processed bucket
6. **Logging**: All operations logged to CloudWatch

## 🔍 Data Validation
The pipeline validates:
- **Field Existence**: Required fields present
- **Data Types**: String validation for text fields
- **Content Quality**: Non-empty, non-whitespace values
- **Structure**: List format with valid records

## 🚨 Error Handling
- **Validation Errors**: Detailed error reports stored in S3
- **Processing Failures**: Graceful degradation with logging
- **Infrastructure Issues**: Terraform state management
- **Monitoring**: CloudWatch alarms and metrics

## 🔒 Security Features
- **Encryption**: S3 server-side encryption (AES256)
- **Access Control**: IAM policies with least privilege
- **Audit Logging**: CloudTrail integration ready

## 📈 Monitoring & Observability
- **CloudWatch Logs**: For Centralized logging
- **Metrics**: Lambda execution metrics
- **Alarms**: Error rate monitoring Alarms can be integrated
---