# ⚡ Apache Spark Structured Streaming Module

المسؤول: **فيبرونيا (Febronia)** | Processing Engineer

---

## 🎯 دور المكون
استهلاك الرسائل المعالجة من كافكا (`crashes.cleaned`) عبر Spark Structured Streaming، وتطبيق الـ Schema المعتمدة، ثم تمرير الـ Micro-batches لحفظها في PostgreSQL عبر دالة `foreachBatch` بنمط Idempotent.

---

## 🚀 التشغيل
```bash
python -m venv .venv
source .venv/bin/activate # أو على ويندوز: .venv\Scripts\activate
pip install -r requirements.txt

# تشغيل التطبيق
python src/spark_consumer.py
```
