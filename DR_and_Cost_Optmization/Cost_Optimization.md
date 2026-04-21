# 💰 Cost Optimization using AWS Feature Karpenter (Spot + On-Demand)

## 📌 Overview
This project demonstrates how to optimize Kubernetes infrastructure costs by using **Karpenter** to dynamically provision nodes with a mix of **Spot and On-Demand instances**.

Karpenter improves:
- Cost efficiency (up to 70% savings using Spot)
- Cluster scalability
- Resource utilization


---

## 🎯 Objectives
- Reduce infrastructure costs
- Automatically provision right-sized nodes
- Use Spot instances for non-critical workloads
- Fallback to On-Demand for reliability

---

## 🧩 Components

### 1. Karpenter
- Kubernetes node provisioning controller
- Replaces traditional Cluster Autoscaler
- Launches nodes based on pod requirements

---

### 2. Spot Instances
- Low-cost (interruptible)
- Used for stateless workloads
- Significant cost savings

---

### 3. On-Demand Instances
- Stable and reliable
- Used for critical workloads
- Backup when Spot capacity unavailable

---

## ⚙️ Installation

### Install Karpenter
```bash id="karp-cmd1"
helm repo add karpenter https://charts.karpenter.sh
helm install karpenter karpenter/karpenter \
  --namespace karpenter --create-namespace