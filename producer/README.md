# 📡 Python Data Producer Module

المسؤول: **روني (Rony)** | Data Engineer

---

## 🎯 دور المكون
قراءة بيانات حوادث الطيران من داتاسيت NTSB التاريخية، وتوحيد السجلات طبقاً للـ Data Contract، وبثها كرسائل JSON إلى Kafka Topic (`crashes.raw`) مع محاكاة التدفق الزمني اللحظي.

---

## 🚀 التشغيل
```bash
python -m venv .venv
source .venv/bin/activate # أو على ويندوز: .venv\Scripts\activate
pip install -r requirements.txt

# تشغيل البث بسرعة 1.5 ثانية لكل رسالة ودفعات من 50 سجلاً
python src/producer.py --speed 1.5 --batch-size 50
```
