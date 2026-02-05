# OpenEdX on AWS EKS — Technical Assessment Submission (Al Nafi)

**Assessment:** OpenEdX Deployment on Kubernetes (AWS EKS)  
**Cloud:** AWS ONLY  
**Method:** Tutor (latest stable) + `tutor-k8s` plugin  
**Ingress:** Nginx Ingress Controller (Caddy replaced)  
**Data Services:** External (NOT inside Kubernetes) — MySQL, MongoDB, Elasticsearch/OpenSearch, Redis  
**Security:** CloudFront + AWS WAF  
**Ops:** HPA, PV/PVC, probes, monitoring/logging, backups

---

## 1. Executive Summary

This repository contains a **production-ready OpenEdX (LMS/CMS/workers)** deployment on **AWS EKS**, following an enterprise-grade architecture:

**WAF → CloudFront → ALB → Nginx Ingress → OpenEdX Pods (EKS)**  
Data services are **externalized** (AWS managed services or dedicated EC2), and **no databases run inside Kubernetes**.

Key capabilities:
- Namespace isolation for OpenEdX components
- Nginx Ingress for reverse proxy + TLS termination + HTTP/2
- External MySQL + MongoDB + Elasticsearch/OpenSearch + Redis
- PV/PVC for uploads/media
- HPA for LMS/CMS
- Liveness/readiness probes
- Centralized monitoring/logging
- Backup and restore strategy for DBs and volumes
- Evidence artifacts: screenshots, logs, load test results

---

## 2. Reference Architecture

### 2.1 High-Level Flow
1) Client requests → **AWS WAF**
2) WAF → **CloudFront** (CDN + caching for static assets)
3) CloudFront → **ALB**
4) ALB → **Nginx Ingress Controller**
5) Ingress routes to **LMS/CMS/Workers** running on **EKS**
6) OpenEdX uses external data stores:
   - **MySQL**: application relational data
   - **MongoDB**: course/user document data
   - **Elasticsearch/OpenSearch**: search/analytics
   - **Redis**: cache/message broker

### 2.2 Diagram
- Architecture diagram: `diagrams/architecture-diagram.png`
- Network flow diagram: `diagrams/network-flow-diagram.png`

---

## 3. AWS Services Used

### 3.1 Kubernetes
- **EKS** cluster with managed node groups
- OIDC provider enabled for IRSA

### 3.2 External Data Services (choose what you used)
- MySQL: **Amazon RDS (MySQL/Aurora)** OR EC2-based MySQL
- MongoDB: **Amazon DocumentDB** OR EC2-based MongoDB
- Elasticsearch: **Amazon OpenSearch Service** OR EC2-based Elasticsearch
- Redis: **Amazon ElastiCache for Redis** OR EC2-based Redis

> NOTE: Data services are external to the cluster as required.

### 3.3 Web & Security
- **Nginx Ingress Controller** (replaces Caddy)
- **AWS Load Balancer Controller** for ALB integration
- **CloudFront** for static assets
- **AWS WAF** integrated with CloudFront distribution

### 3.4 Storage
- EBS (gp3) dynamic PV provisioning OR EFS (shared) depending on design
- PV/PVC for uploads/media

### 3.5 Monitoring/Logging
- Prometheus + Grafana (or equivalent)
- Optional: CloudWatch Container Insights / Fluent Bit

---

## 4. Repository Structure
```text
.
├── README.md
├── docs/
│   ├── deployment-guide.md
│   ├── troubleshooting.md
│   └── decisions.md
├── scripts/
│   ├── deploy.sh
│   ├── backup.sh
│   ├── restore.sh
│   └── validate.sh
├── kubernetes/
│   ├── manifests/
│   │   ├── 00-namespace.yaml
│   │   └── 01-secrets-template.yaml
│   ├── ingress/
│   │   └── nginx-ingress-values.yaml
│   ├── hpa/
│   │   ├── lms-hpa.yaml
│   │   └── cms-hpa.yaml
│   └── external-secrets/
├── tutor/
│   └── (tutor config and overrides)
├── nginx/
│   └── notes.md
├── monitoring/
│   └── notes.md
└── diagrams/
    ├── architecture-diagram.png
    └── network-flow-diagram.png
