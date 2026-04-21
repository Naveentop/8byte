# By running one of the Disaster Recovery Strategy i.e., WARM STANDB
For Example.

* We are running a customer-facing e-commerce application on AWS.
=> Architecture (Primary Region – ap-south-1)
    ALB → EKS (Multi-AZ)
    RDS MySQL (Multi-AZ)
    S3 for product images
    Route 53 for DNS

* Daily business revenue depends on this app

Step 1: Business Impact Analysis (BIA)
Impact      Area Observation
Revenue	    ₹2 lakhs/hour loss if app is down
Customers	Users abandon cart after 10–15 minutes
SLA	        99.9% availability
Compliance	Payment data must not be lost

📌 Business Decision
        Max acceptable downtime: 30 minutes 
        Max acceptable data loss: 5 minutes

Step 2: Define RTO & RPO

RTO = 30 minutes
👉 App must be fully available within 30 minutes

RPO = 5 minutes
👉 Max 5 minutes of order/payment data loss allowed

Step 3: Validate Against Current AWS Setup
Current Setup (Before DR Improvements)
Component	    Setup	    Limitation
RDS	            Daily snapshot	❌ RPO = 24 hours
EKS	            Single region	❌ Manual rebuild
S3	            No CRR	        ❌ Data loss risk
DNS	            Manual switch	❌ High RTO

❌ Current setup does NOT meet RTO/RPO

Step 4: AWS DR Design to Meet RTO/RPO
DR Region – ap-southeast-1
Data Layer

* RDS Cross-Region Read Replica
    Lag: ~1–2 minutes → ✅ RPO met
* S3 Cross-Region Replication
    Near real-time → ✅ RPO met
* Application Layer
    EKS cluster pre-created (Warm Standby)
    Minimal node group running
    Images stored in ECR (cross-region replication)
* Traffic & Failover
    Route 53 failover routing
    Health checks every 30 seconds
    TTL = 60 seconds

Step 5: Calculate Actual RTO
Recovery        Step	    Time
Detect failure (CloudWatch)	2 min
Route 53        failover	1–2 min
Scale EKS in DR region	    10 min
Promote RDS read replica	5 min
App health verification	5 min
✅ Total RTO ≈ 23–25 minutes

✔ Meets 30 min RTO

Step 6: Calculate Actual RPO
Data Source	Replication Method	Data Loss
Orders (RDS)	Cross-region replica	1–2 min
Images (S3)	CRR	Near-zero
Sessions (Redis)	Not replicated	Acceptable loss
✅ Actual RPO ≈ 2 minutes

✔ Meets 5 min RPO

Step 7: Final DR Summary (What You Document)
Item	Value
Application Tier	Tier-1
RTO	30 minutes
RPO	5 minutes
DR Strategy	Warm Standby
AWS Services Used	Route 53, RDS RR, S3 CRR, EKS
🔑 Interview-Ready One-Liner

*** 
“We calculated RTO and RPO using business impact analysis. Based on a 30-minute RTO and 5-minute RPO, we implemented a warm-standby DR architecture in AWS using cross-region RDS replicas, S3 replication, and Route 53 automated failover, which we validated through DR drills.” 
***