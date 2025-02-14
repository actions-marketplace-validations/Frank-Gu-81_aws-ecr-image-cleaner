# AWS ECR Cleanup Tool

## Overview

This GitHub Action automatically deletes old Docker images from an AWS ECR repository, keeping only the latest N images.

## Features

✅ Fully automated cleanup  
✅ Allows users to specify the number of images to retain  
✅ Works with GitHub Actions

## Usage

### **1. Add the Action to Your Workflow**

Create a `.github/workflows/cleanup.yml` file:

```yaml
name: Cleanup ECR Images

on:
  schedule:
    - cron: "0 0 * * 1"
  workflow_dispatch:

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Cleanup Old Images
        uses: Frank-Gu-81/aws-ecr-image-cleaner@v1.0.0
        with:
          repository-name: "ecr-repo-to-cleanup"
          keep-images: 3
```

### **2. Required GitHub Secrets**

| Secret Name  |          Description          |
| :----------- | :---------------------------: |
| `AWS_ROLE`   | IAM Role with ECR permissions |
| `AWS_REGION` | AWS region (e.g., us-east-1)  |

### **3. Permission Required**

Your IAM role must have the following policies:

```json
{
  "Effect": "Allow",
  "Action": ["ecr:DescribeImages", "ecr:BatchDeleteImage"],
  "Resource": "*"
}
```
