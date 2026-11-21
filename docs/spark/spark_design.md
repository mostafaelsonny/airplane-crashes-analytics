# ⚡ Spark Structured Streaming Design
المسؤول: **فيبرونيا (Febronia)** | Processing Engineer

---

## 1. استهلاك كافكا وتطبيق الـ Schema
* قراءة Stream من كافكا (`crashes.cleaned`).
* تحويل الـ JSON Value إلى أعمدة باستخدام `StructType` مطابق للـ Data Contract.

---

## 2. استراتيجية الـ foreachBatch
* استخدام `writeStream.foreachBatch(write_to_postgres)` لتمرير كل Micro-batch إلى قاعدة بيانات PostgreSQL.
* تنفيذ استعلام الـ Upsert عبر Connection Pool لمنع تكرار السجلات عند إعادة معالجة أي Micro-batch.
* تفعيل الـ Checkpointing لاستعادة حالة التدفق دون فقدان بيانات.
