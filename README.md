# ✈️ Real-Time Airplane Crashes Analytics
### منصة معالجة وتدفق وتحليل بيانات حوادث الطيران لحظياً (Big Data Streaming Pipeline)

![Architecture](https://img.shields.io/badge/Architecture-Event--Driven%20Streaming-blue)
![Kafka](https://img.shields.io/badge/Apache%20Kafka-2.8%2B-black?logo=apachekafka)
![NiFi](https://img.shields.io/badge/Apache%20NiFi-1.20%2B-blue?logo=apachenifi)
![Spark](https://img.shields.io/badge/Apache%20Spark-Structured%20Streaming-orange?logo=apachespark)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![Status](https://img.shields.io/badge/Sprint%201-In%20Progress-green)

---

## 📖 نظرة عامة على المشروع (Project Overview)
مشروع تخرج تطبيقي لمقرر **هندسة البيانات الضخمة (Big Data Course - Project #5)**.  
يهدف المشروع إلى بناء منصة هندسية متكاملة لجمع، وتنظيف، وبث، ومعالجة، وتخزين بيانات حوادث الطيران التاريخية واللحظية الصادرة عن الهيئة الوطنية لسلامة النقل الأمريكية (**NTSB - National Transportation Safety Board**)، وتحويلها إلى تيار بيانات حي (Real-time Stream) يتيح تحليل اتجاهات الحوادث، والسلامة الجوية، وتوزيع الإصابات جغرافياً وزمنياً.

> **المدة الزمنية الإجمالية:** 3 أسابيع (مقسمة إلى Sprints).  
> **هدف Sprint 1:** تأسيس البنية التحتية، اعتماد عقد البيانات الموحد (Data Contract)، وبناء خط أنابيب متكامل لإثبات المفهوم (**End-to-End Proof of Concept**) يربط بين:  
> `Python Producer ➔ Apache Kafka ➔ Apache NiFi ➔ Apache Spark Structured Streaming ➔ PostgreSQL`.

---

## 🎯 المشكلة التي نحلها (Problem Statement)
بيانات حوادث الطيران تتسم بكونها:
1. **موزعة وغير موحدة:** مخزنة في قواعد بيانات معقدة (Microsoft Access Database Files) وجداول متعددة ومنفصلة.
2. **تحتوي على بيانات مفقودة ومشوهة:** حقول التواريخ والمواقع والإصابات تتطلب معالجة وتدقيق مستمر.
3. **غياب الرؤية اللحظية:** صعوبة معالجة وتجميع الحوادث لحظة وقوعها ومقارنتها بالنماذج التاريخية.

يقوم هذا النظام ببناء مسار تدفق مؤتمت بالكامل يقوم باستخراج السجلات، وبثها كرسائل لحظية، وتمريرها عبر طبقات الفلترة والمعالجة الموزعة، ثم تخزينها بنمط يضمن عدم التكرار (**Idempotent Storage**).

---

## 🏗️ المعمارية العامة للبيانات (System Architecture)

```text
 ┌────────────────────────────────────────────────────────┐
 │            NTSB Historical Aviation Dataset            │
 └───────────────────────────┬────────────────────────────┘
                             │ (Extraction & Normalization)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │           Python Producer (Event Simulator)            │
 └───────────────────────────┬────────────────────────────┘
                             │ (JSON Messages)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │            Apache Kafka (Topic: crashes.raw)           │
 └───────────────────────────┬────────────────────────────┘
                             │ (Consume Raw FlowFile)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │       Apache NiFi (ETL / Validation / Formatting)      │
 └─────────────┬────────────────────────────┬─────────────┘
               │ (Valid Records)            │ (Invalid / Corrupted)
               ▼                            ▼
 ┌───────────────────────────┐    ┌───────────────────────┐
 │ Kafka: crashes.cleaned    │    │ Kafka: crashes.dlq    │
 └─────────────┬─────────────┘    └───────────────────────┘
               │ (Consume Clean Stream)
               ▼
 ┌────────────────────────────────────────────────────────┐
 │      Apache Spark Structured Streaming (PySpark)       │
 └───────────────────────────┬────────────────────────────┘
                             │ (foreachBatch / Micro-batches)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │    PostgreSQL (Table: accidents / Idempotent Upsert)   │
 └───────────────────────────┬────────────────────────────┘
                             │ (SQL Analytical Queries)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │       Streamlit Analytics Dashboard (Sprint 2)         │
 └────────────────────────────────────────────────────────┘
```

---

## 🧰 حزمة التقنيات المستخدمة (Technology Stack)

| المكون | التقنية | الإصدار | سبب الاستخدام والمسؤولية |
|---|---|---|---|
| **Data Ingestion** | Python | 3.11+ | استخراج بيانات NTSB التاريخية، وتوحيد السجلات وبثها كـ Stream لحظي. |
| **Message Broker** | Apache Kafka | 2.8+ / KRaft | وسيط رسائل موزع وفائق السرعة لتمرير البيانات بين المكونات بدون فقدان. |
| **Data ETL & Routing** | Apache NiFi | 1.20+ | واجهة بصرية لفلترة السجلات، وتوحيد الصيغ، وعزل البيانات المعطوبة في DLQ. |
| **Stream Processing** | Apache Spark | 3.5.0 | محرك معالجة البيانات الضخمة اللحظي (Structured Streaming) وتطبيق الـ Schema. |
| **Database** | PostgreSQL | 15 Alpine | التخزين الدائم لبيانات الحوادث المعالجة مع دعم استعلامات الـ Upsert الذكية. |
| **Infrastructure** | Docker & Compose | v2+ | توحيد بيئة التشغيل للخدمات وضمان عملها بنقرة واحدة على أي جهاز. |
| **Task Management** | Trello | Cloud | تتبع مهام السبرنت، والاعتماديات اليومية، ومعايير الجودة DoD. |

---

## 👥 فريق العمل وتوزيع الأدوار (Team & Responsibilities)

| العضو | الدور الإداري والمعماري | المسؤولية التقنية الأساسية في المشروع |
|---|---|---|
| 👑 **مصطفى (Mostafa)** | **Team Leader & Architect** | إدارة المشروع، مراجعة واعتماد الـ PRs، المعمارية العامة، واختبار التكامل الشامل. |
| 📊 **روني (Rony)** | **Data Engineer** | فحص داتاسيت NTSB، استخراج الحقول، وبناء الـ Python Producer ومحاكي البث. |
| ⚙️ **روان (Rovan)** | **Infrastructure Engineer** | تجهيز Docker Compose، ضبط مواضيع كافكا (Topics)، وتأمين الشبكات والمنافذ. |
| 🔄 **إبراهيم (Ebrahim)** | **ETL Engineer** | تصميم وتفعيل تدفق Apache NiFi، التحقق من البيانات، وتوجيه مسار الـ DLQ. |
| ⚡ **فيبرونيا (Febronia)** | **Processing Engineer** | *(تبديل الدور المعتمد)* بناء تطبيق Spark Structured Streaming، و `foreachBatch` والـ Checkpointing. |
| 🗄️ **منذر (Monzer)** | **Database Engineer** | *(تبديل الدور المعتمد)* تصميم قاعدة بيانات PostgreSQL، جداول الحوادث، واستعلام الـ Upsert المانع للتكرار. |

---

## 📁 هيكل مجلدات المشروع (Repository Structure)

```text
airplane-crashes-analytics/
├── .github/                         # قواعد وحوكمة GitHub والـ PR Templates
│   ├── ISSUE_TEMPLATE/              # استمارات الإبلاغ عن المهام والأخطاء
│   ├── rulesets/                    # قواعد حماية الفروع الصارمة (main & develop)
│   ├── workflows/ci.yml             # خط أنابيب الفحص الآلي المستمر
│   ├── CODEOWNERS                   # تخصيص ملكية ومراجعة الكود لقائد الفريق
│   └── pull_request_template.md     # نموذج الـ PR الإلزامي الشامل
│
├── docs/                            # التوثيق المعماري والتقني الإلزامي
│   ├── architecture/                # المعمارية العامة واختبار التكامل الشامل
│   ├── data/                        # قاموس البيانات والعقد الموحد (Data Contract)
│   ├── infrastructure/              # تعليمات البيئة ومواضيع كافكا
│   ├── nifi/                        # توثيق تدفق NiFi
│   ├── spark/                       # تصميم تطبيق Spark Streaming
│   └── database/                    # تصميم جدول الحوادث واستعلامات الـ Upsert
│
├── producer/                        # موديول بايثون لتوليد وبث البيانات
│   ├── src/                         # data_reader.py, serializer.py, simulator.py, producer.py
│   ├── tests/                       # اختبارات الـ Producer وعينات البيانات
│   ├── requirements.txt
│   └── README.md
│
├── nifi/                            # موديول Apache NiFi
│   ├── flows/                       # ملفات Flow Templates المصدرة (JSON/XML)
│   └── README.md
│
├── spark/                           # موديول معالجة التدفق اللحظي بـ Spark
│   ├── src/                         # spark_consumer.py, schema.py, postgres_writer.py
│   ├── tests/                       # اختبارات المعالجة
│   ├── requirements.txt
│   └── README.md
│
├── database/                        # موديول قاعدة بيانات PostgreSQL
│   ├── init/                        # 001_create_tables.sql (جداول الحوادث والفهارس)
│   ├── migrations/                  # التعديلات المستقبلية
│   └── README.md
│
├── infrastructure/                  # البنية التحتية وحاويات دوكر
│   ├── docker-compose.yml           # تشغيل Kafka, Zookeeper, NiFi, PostgreSQL
│   ├── .env.example                 # متغيرات البيئة المعيارية
│   └── README.md
│
├── tests/                           # اختبارات التكامل
│   └── integration/                 # End-to-End System Tests
│
├── .editorconfig
├── .gitignore                       # استثناء الملفات المؤقتة والبيانات الضخمة
├── CONTRIBUTING.md                  # دليل وقواعد المساهمة الصارمة
├── Makefile                         # أوامر التشغيل السريع
└── README.md                        # الدليل التعريفي للمشروع
```

---

## 🚀 دليل التشغيل السريع (Quick Start Guide — خطوة بخطوة)

إذا كنت تبدأ العمل على المشروع لأول مرة، اتبع هذا الدليل لوضع قدمك على الطريق وتشغيل النظام بالكامل:

### 1. استنساخ المستودع (Clone Repository)
```bash
git clone https://github.com/mostafaelsonny/airplane-crashes-analytics.git
cd airplane-crashes-analytics
```

### 2. تجهيز متغيرات البيئة (Environment Variables)
```bash
cp infrastructure/.env.example infrastructure/.env
# على بيئة Windows PowerShell:
# Copy-Item infrastructure/.env.example infrastructure/.env
```

### 3. تشغيل البنية التحتية عبر Docker
تأكد من تشغيل **Docker Desktop**، ثم شغّل الأمر التالي لتشغيل Kafka و PostgreSQL و NiFi في الخلفية:
```bash
docker compose -f infrastructure/docker-compose.yml up -d
```
* **فحص حالة الحاويات:**
  ```bash
  docker compose -f infrastructure/docker-compose.yml ps
  ```

### 4. التحقق من مواضيع كافكا (Kafka Topics)
```bash
docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092
# يجب أن تظهر المواضيع: crashes.raw, crashes.cleaned, crashes.dlq
```

### 5. التحقق من قاعدة بيانات PostgreSQL
```bash
docker exec -it postgres psql -U postgres -d airplane_crashes_db -c "\dt"
# للتأكد من وجود جدول accidents
```

### 6. تشغيل واجهة Apache NiFi
* افتح المتصفح على الرابط: `https://localhost:8443/nifi` (أو `http://localhost:8080/nifi`).
* استخرج بيانات الدخول عبر:
  ```bash
  docker logs nifi | grep -i "Generated Username" -A 1
  ```
* تأكد من تفعيل Process Group: `Aircraft Accidents ETL`.

### 7. تشغيل تطبيق Spark Streaming (المعالج اللحظي)
```bash
cd spark
python -m venv .venv
source .venv/bin/activate # أو على ويندوز: .venv\Scripts\activate
pip install -r requirements.txt
python src/spark_consumer.py
```

### 8. تشغيل الـ Python Producer (محاكي الأحداث)
في Terminal منفصل:
```bash
cd producer
python -m venv .venv
source .venv/bin/activate # أو على ويندوز: .venv\Scripts\activate
pip install -r requirements.txt
python src/producer.py --speed 1.5 --batch-size 50
```

### 9. التحقق من وصول البيانات لحظياً إلى قاعدة البيانات
```bash
docker exec -it postgres psql -U postgres -d airplane_crashes_db -c "SELECT count(*), max(created_at) FROM accidents;"
```

---

## 📌 إدارة المهام ولوحة Trello (Trello Board)
تتم إدارة وتتبع كافة تفاصيل المهام اليومية وجداول السبرنت عبر اللوحة التفاعلية:  
🔗 **[لوحة Trello الرسمية لـ Sprint 1](https://trello.com/b/mZwlslLk/real-time-airplane-crashes-analytics-sprint-1)**

---

## ⚖️ ميثاق الشرف الأكاديمي وقواعد المساهمة (Academic Policy)
* **المساهمة محكومة بقواعد صارمة:** راجع دليل [CONTRIBUTING.md](CONTRIBUTING.md).
* **ممنوع تماماً الرفع المباشر** على `main` أو `develop`؛ كافة التغييرات تخضع لمراجعة مصطفى (Team Leader) وموافقته.
* **الفهم الفني التام:** لن يُسمح بدمج أي كود لا يستطيع كاتبه شرح آليته وخوارزميته بالتفصيل، استعداداً لمناقشة المقرر الأكاديمي.
