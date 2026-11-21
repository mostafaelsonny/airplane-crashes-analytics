# 🗄️ PostgreSQL Database Schema Specification
المسؤول: **منذر (Monzer)** | Database Engineer

---

## 1. تصميم جدول الحوادث (`accidents`)
* `event_id`: Primary Key (فريد وغير قابل للتكرار).
* `event_date`: تاريخ الحادث (DATE).
* `fatal_injuries`, `serious_injuries`, `minor_injuries`: أعداد صحيحة `>= 0`.
* `created_at`, `updated_at`: طوابع زمنية للتدقيق ومتابعة التحديثات.

---

## 2. استعلام الـ Idempotent Upsert
```sql
INSERT INTO accidents (...) VALUES (...)
ON CONFLICT (event_id) DO UPDATE SET ...;
```
يضمن هذا الاستعلام أنه إذا أرسل Spark نفس السجل مراراً وتكراراً، يتم تحديث السجل القائم دون إحداث أخطاء Duplicate Key ودون زيادة عدد الصفوف.
