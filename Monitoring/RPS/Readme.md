# 🚦 RPS Configuration using Kubernetes ConfigMap

## 📌 Overview
This RPS demonstrates how to control **Requests Per Second (RPS)** using a Kubernetes ConfigMap.  
The application reads RPS limits dynamically from the ConfigMap, enabling runtime configuration without rebuilding the image.

---
Ingress / Load Balancer → Application Pod → ConfigMap (RPS Config)

## 🧩 Architecture