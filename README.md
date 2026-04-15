# 📊 Medical Appointments No-Show Analysis (SQL Server)

## 🧠 Overview
This project analyzes patient appointment data to understand the factors associated with **no-show behavior**.

The goal is to identify key drivers of missed appointments and provide actionable insights to improve patient attendance.

---

## 🎯 Objective
- Measure the overall no-show rate  
- Identify key factors influencing attendance  
- Generate data-driven recommendations  

---

## ⚙️ Tools & Skills
- SQL Server  
- Data Cleaning  
- Data Quality Analysis  
- Exploratory Data Analysis (EDA)

## 🐳 Environment Setup

This project was developed using **SQL Server running on Docker**.

This setup allowed for a reproducible and isolated environment, simulating a real-world data engineering workflow.


---

## 🧹 Data Preparation

- Removed duplicates based on `appointment_id`
- Filtered invalid records:
  - Age < 0 or > 100  
  - Negative waiting time  
- Cleaned encoding issues in `neighbourhood`
- Created final dataset: `appointments_clean_final`

---

## 📌 Key Metric

### No-Show Rate
- **20.19% of appointments result in no-show**

👉 Approximately **1 in 5 patients does not attend their appointment**

---

## 📊 Key Analyses

### 👤 Age

| Group | No-show rate |
|------|-------------|
| 18–35 | **23.81%** |
| 0–17 | 21.90% |
| 36–60 | 19.10% |
| 60+ | **15.20%** |

👉 Younger patients are more likely to miss appointments  

---

### 📩 SMS Reminder

| SMS Received | No-show rate |
|-------------|-------------|
| No | 16.70% |
| Yes | 27.58% |

⚠️ At first glance, SMS reminders appear to increase no-show rates  

---

### ⏱️ Waiting Time (Key Variable)

> Waiting time is defined as the number of days between when the appointment was scheduled and the actual appointment date.

| Waiting Time | No-show rate |
|-------------|-------------|
| Same day | **4.65%** |
| 1–3 days | 22.88% |
| 4–7 days | 25.20% |
| 7+ days | **32.06%** |

👉 **Strong relationship:**  
Longer waiting time → higher no-show rate  

---

### 🔍 SMS + Waiting Time (Critical Insight)

For patients with longer waiting times:

- **7+ days**
  - No SMS → 36.04%
  - SMS → **29.42%**

👉 SMS reminders **reduce no-show in high-risk patients**

---

## 🧠 Key Insight

Waiting time is the main driver of no-show behavior.  
SMS reminders are effective only when targeted to high-risk patients.

👉 The initial SMS result was affected by **selection bias (confounding effect)**

---

## 🏥 Health Conditions

| Condition | No-show rate |
|----------|-------------|
| Hypertension (Yes) | 17.30% |
| Hypertension (No) | 20.90% |
| Diabetes (Yes) | 18.00% |
| Diabetes (No) | 20.36% |
| Alcoholism | ~20% |

👉 Patients with chronic conditions tend to attend more regularly  

---

## 📅 Day of the Week

| Day | No-show rate |
|-----|-------------|
| Saturday | 23.08% |
| Friday | 21.23% |
| Monday | 20.64% |
| Tuesday | 20.09% |
| Wednesday | 19.69% |
| Thursday | **19.34%** |

👉 Slight variation across days, with higher rates toward the end of the week  

---

## 📍 Geographic Patterns

Top neighbourhoods with highest no-show rates:

- SANTOS DUMONT → **28.92%**
- SANTA CECÍLIA → 27.46%
- SANTA CLARA → 26.48%
- ITARARÉ → 26.27%

👉 Indicates location-based behavioral differences  

---

## 💡 Conclusions

- No-show rate is significant (~20%)  
- Waiting time is the strongest predictor  
- Younger patients are higher risk  
- Chronic patients are more compliant  
- SMS works when properly targeted  
- Behavioral patterns vary by time and location  

---

## 🚀 Business Recommendations

- Reduce waiting times whenever possible  
- Target SMS reminders to high-risk patients  
- Focus on younger patient engagement  
- Monitor high-risk neighbourhoods  
- Optimize scheduling strategies  

---

## 💡 About This Project

This project was developed in a short time frame to demonstrate rapid learning and practical application of **SQL Server** for real-world data analysis.
