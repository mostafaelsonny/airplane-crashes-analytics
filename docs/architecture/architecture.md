# 🏛️ Architecture & System Blueprint
### Real-Time Airplane Crashes Analytics

المسؤول: **مصطفى (Mostafa)** | Team Leader & System Architect

---

## 1. الرؤية المعمارية (Architectural Vision)
تم تصميم النظام ليكون خط أنابيب لمعالجة البيانات اللحظية (Distributed Real-time Streaming Pipeline) قائم على نمط الـ Event-Driven Architecture.

```text
NTSB Dataset ➔ Python Producer ➔ Kafka (crashes.raw) ➔ NiFi ➔ Kafka (crashes.cleaned) ➔ Spark Structured Streaming ➔ PostgreSQL
```

---

## 2. مسؤوليات المكونات (Component Boundaries)
1. **Python Data Producer (روني):** قراءة داتاسيت NTSB التاريخية، وتوحيد السجلات طبقاً للـ Data Contract، وبثها بفواصل زمنية محاكية للواقع.
2. **Apache Kafka (روان):** الوسيط اللحظي لتوزيع الرسائل بين المراحل، مع فصل البيانات الخام (`crashes.raw`) عن النظيفة (`crashes.cleaned`) وسجلات الأخطاء (`crashes.dlq`).
3. **Apache NiFi (إبراهيم):** استهلاك السجلات الخام، فحص اكتمال الحقول، توحيد صيغ التواريخ، وعزل البيانات المشوهة في مسار الـ DLQ.
4. **Apache Spark Structured Streaming (فيبرونيا):** استهلاك السجلات النظيفة عبر محرك المعالجة اللحظية الموزع، وتطبيق الـ StructType Schema، وتخزين الـ Micro-batches في PostgreSQL عبر `foreachBatch`.
5. **PostgreSQL Database (منذر):** المستقر النهائي للبيانات، مع تطبيق قيود المفتاح الأساسي واستعلام الـ Upsert لضمان الـ Idempotency وعدم تكرار الحوادث.
6. **Integration & Architecture Governance (مصطفى):** مراجعة الكود، ضبط معايير الجودة، وإدارة الـ Pull Requests، وقيادة اختبار التكامل الشامل.
