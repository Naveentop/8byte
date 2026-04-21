# AWS 3-Tier Architecture (Frontend + Backend + Database)

### Components:
- VPC with public & private subnets
- EC2 instances for application layer
- Application Load Balancer (ALB) for frontend traffic
- PostgreSQL RDS for database layer

---

---

## 🎯 Objectives
- High availability across multiple AZs
- Secure network isolation
- Scalable frontend and backend
- Managed database service

---

## 🧩 Components

### 1. VPC
- CIDR: 10.0.0.0/16
- Public Subnets → ALB
- Private Subnets → EC2 & RDS
- Internet Gateway + Route Tables
- NAT Gateway for outbound traffic

---

### 2. Application Load Balancer (Frontend)
- Internet-facing ALB
- Listens on port 80/443
- Routes traffic to EC2 instances
- Health checks enabled

---

### 3. EC2 (Application Layer)
- Deployed in private subnets
- Hosts backend/frontend services
- Auto Scaling Group
- Security group allows traffic only from ALB

---

### 4. PostgreSQL (RDS)
- Engine: PostgreSQL
- Runs in private subnets
- Multi-AZ (optional for production)
- Accessible only from EC2 security group

---

## 🔐 Security Design

| Layer | Access |
|------|-------|
| ALB  | Public (80/443) |
| EC2  | Only from ALB SG |
| RDS  | Only from EC2 SG |

- No direct internet access to EC2 or DB
- Uses security group chaining
- Secrets stored securely (not in code)

---

## ⚙️ Deployment Steps

terraform init
terraform plan
terraform apply