# 🚀 CI/CD Pipeline with Shift-Left Strategy

## 📌 Overview
This pipeline implements a **shift-left approach**, ensuring that code quality, security, and testing are validated early in the development lifecycle to reduce defects and improve release speed.

---

## 🧩 Pipeline Stages

### 1. Pre-Commit (Local Developer Checks)
- Except staging and production env, Once developer commit the code, pipeline trigger automatically 
   through webhooks. But, In the Stgging and Production, Use PR before merging the code.

### 2. Source Stage
- Code pushed to repository
- Pull Request (PR) triggered

### 3. Build Stage
- Compile / package application
- Dependency installation

### 4. Shift-Left Quality Gates
- ✅ Unit Tests (coverage enforcement)
- ✅ Static Code Analysis (SAST)
- ✅ Code Quality Checks (SonarQube) 
- ✅ Dependency Vulnerability Scan (SCA)
- ✅ Integration Test(Code Quality)
- ✅ Image Scanning in ECR (Trivy)

> ❗ Pipeline fails here if thresholds are not met

### 5. Containerization
- Build Docker image
- Scan image for vulnerabilities

### 6. Integration Testing
- API / integration tests
- Test environment validation

### 7. Deployment (CD)
- Deploy to Dev → QA → Prod
- Approval gates for higher environments

---

## 🛠️ Tools Used
- CI/CD: Jenkins / Azure DevOps / GitHub Actions  
- Code Quality: SonarQube  
- Security: Trivy / OWASP tools
- Container: Docker
- Artifactory: Sonatype Nexus Artifactory
- Orchestration: Kubernetes  
- IaC: Terraform  

---

## 📊 Shift-Left Principles Applied
- Early validation of code quality and security  
- Fail fast on PR stage  
- Automated testing before build artifacts  
- Continuous feedback to developers  

---

### Trigger Pipeline
```bash
git push origin feature-branch