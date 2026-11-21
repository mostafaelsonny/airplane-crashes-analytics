# 🔄 Apache NiFi ETL Module

المسؤول: **إبراهيم (Ebrahim)** | ETL Engineer

---

## 🎯 دور المكون
بناء وإدارة تدفق البيانات المرئي (Visual Flow) لسحب الرسائل من `crashes.raw`، والتحقق من صحتها وتنسيقها، ونشر السجلات الصالحة إلى `crashes.cleaned` والبيانات المشوهة إلى `crashes.dlq`.

---

## 📂 المجلدات
* `flows/`: يحتوي على ملفات التدفق المصدرة بصيغة NiFi Template (JSON / XML).
