# DevOps Technical Assignment - Scenario 1
## Incremental/Decremental Counter with AWS Infrastructure

This project implements a complete DevOps solution for Scenario 1, featuring a highly available web application infrastructure on AWS using Terraform, with automated CI/CD pipeline for deployment.

## 🏗️ Architecture Overview

### **Infrastructure Components:**
- **Application Load Balancer (ALB)** - Public-facing, deployed in default VPC public subnets
- **Auto Scaling Group** - 3 EC2 instances (t2.micro) running nginx in private subnets
- **Private S3 Bucket** - Stores web content with encryption and versioning
- **NAT Gateway** - Provides internet access for private subnet instances
- **Security Groups** - Restricts access to port 80/TCP only
- **IAM Roles** - Secure S3 access for EC2 instances

### **Network Architecture:**
```
Internet
    |
Internet Gateway (Default VPC)
    |
Public Subnets (Default) ── ALB ── Target Group
    |                              |
NAT Gateway                        |
    |                              |
Private Subnets (Created) ── EC2 Instances (nginx)
                                   |
                              Private S3 Bucket
```

## 📋 Requirements Fulfilled

### **Core Infrastructure:**
- Highly available auto-scaling group of 3 AWS EC2s (Server fleet A, t2.micro)
- Running nginx to serve public web content
- Behind a public ALB in Singapore region (ap-southeast-1)
- EC2 servers download content from private S3 bucket on boot
  Uses default VPC with existing Internet Gateway, public subnets, default routing
- Creates private subnets via Terraform

### ✅ **Security & Access:**
- Restricts inbound access to ALB and Server Fleet A to port 80/TCP only
- Installs Nginx on Amazon Linux 2
- Accessible from public internet
- Private S3 bucket with proper IAM roles

### ✅ **Web Application:**
- Incremental/Decremental Counter implementation
- All text changed to uppercase as required
- Proper HTML, CSS, JavaScript structure

### ✅ **CI/CD Pipeline:**
- GitLab pipeline updates S3 bucket on master/main branch merge
- Triggers instance refresh of ASG after successful S3 push
- Automated deployment workflow


## 📁 Project Structure

```
scenario1-terraform-aws-cidi/
├── README.md
└── terraform
    ├── backend
    │   ├── main.tf
    │   ├── variables.tf
    │   └── version.tf
    └── infra
        ├── data.tf
        ├── iam.tf
        ├── main.tf
        ├── network.tf
        ├── outputs.tf
        ├── s3-objects.tf
        ├── security-groups.tf
        ├── security.tf
        ├── storage.tf
        ├── terraform.tfvars
        ├── user_data.sh
        ├── variables.tf
        ├── versions.tf
        └── web-content
            ├── index.html
            ├── script.js
            └── style.css
```

## 🏆 Architectural Improvements Recommendations

The current setup works, but it's not ideal for a real-world dynamic application. Here are the next practical steps to make it production-ready.

### 1. Separate the Frontend from the Backend
**Problem:** Right now, we're using EC2 instances just to serve static HTML/CSS/JS files. That's inefficient and slow for users who aren't near the Singapore region.

**Solution:**
* **Move the frontend:** All the frontend code should be in an S3 bucket.
* **Use a CDN:** Put an **Amazon CloudFront** distribution in front of that S3 bucket. This will cache the frontend files at edge locations globally, making the site load much faster for everyone.
* **Repurpose the EC2s:** The EC2 instances should be used for what they're for: running a backend API (e.g., Node.js, Python, Java). The ALB will route all API traffic to these instances.

**Why:** This is a standard three-tier architecture. It's faster, cheaper, and lets us update the frontend and backend independently.

### 2. Add a Proper Database
**Problem:** The application has no database, so it can't store any data. Installing a database on an EC2 instance means we have to manage it, which is a pain.

**Solution:**
* **Use Amazon RDS:** We'll add an RDS instance to our VPC. This gives us a managed database (like PostgreSQL or MySQL) without the headache of patching, backups, or management.
* **Make it High-Availability:** We must configure RDS for **Multi-AZ deployment**. If the primary database's Availability Zone fails, it will automatically failover to the standby replica. No data loss, minimal downtime.

**Why:** It's more reliable and saves us a ton of operational work. Let AWS manage the database so we can focus on the application.

### 3. Use a Real Domain Name with HTTPS
**Problem:** Users are accessing the app via the long, ugly ALB DNS name over insecure HTTP.

**Solution:**
* **Use Route 53:** We'll register a domain name and use Route 53 to point it at our CloudFront distribution (for the frontend) and our ALB (for the backend API).
* **Enable HTTPS:** We'll use **AWS Certificate Manager (ACM)** to get a free SSL certificate. We can then attach this to CloudFront and the ALB so all traffic is encrypted.

**Why:** It's professional and secure. HTTPS is non-negotiable for any modern web application.

### 4. Implement Smart Scaling
**Problem:** The Auto Scaling Group is fixed at 3 instances. This is wasteful during quiet times and might not be enough to handle a sudden traffic spike.

**Solution:**
* **Use Dynamic Scaling Policies:** We'll change the ASG to scale based on metrics. For example: if average CPU goes above 70%, add a new instance. If it drops below 30%, remove one.
* **Confirm Multi-AZ:** Double-check that the ASG is configured to launch new instances across at least two different Availability Zones.

**Why:** This saves money by not running idle instances and ensures the application stays responsive under load. It also protects us from an entire Availability Zone outage.


### **Reference Links:**
- [AWS Auto Scaling Instance Refresh](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html)
- [GeeksforGeeks Counter Tutorial](https://www.geeksforgeeks.org/how-to-make-incremental-and-decremental-counter-using-html-css-and-javascript/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)

### **Contact Information:**
- **Project Repository**: <https://gitlab.com/sispaing/scenario1-terraform-aws-cicd>
- **Documentation**: This README.md
- **Issues**: GitLab Issues tracker

---


