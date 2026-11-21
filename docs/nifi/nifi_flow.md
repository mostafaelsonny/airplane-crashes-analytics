# 🌊 Apache NiFi Flow Design
المسؤول: **إبراهيم (Ebrahim)** | ETL Engineer

---

## 1. تصميم الـ Process Group
* **الاسم:** `Aircraft Accidents ETL`
* **المعالجات الأساسية:**
  1. `ConsumeKafka_2_6`: الاستهلاك من `crashes.raw`.
  2. `ValidateJson` / `EvaluateJsonPath`: استخراج الحقول والتأكد من مطابقة الـ Contract.
  3. `RouteOnAttribute`: التوجيه لمسار `valid` أو `invalid`.
  4. `UpdateRecord` / `JoltTransformJSON`: توحيد التواريخ وإزالة الفراغات.
  5. `PublishKafka_2_6`: البث إما لـ `crashes.cleaned` أو `crashes.dlq`.
