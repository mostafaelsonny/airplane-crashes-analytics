# 🧪 End-to-End System Integration Test Plan
### خطة واختبار التكامل الشامل للمنظومة

المسؤول: **مصطفى (Mostafa - Team Leader)** بمشاركة كافة أعضاء الفريق.

---

## 1. سيناريو الاختبار الكامل (Test Scenario)
1. تشغيل بيئة Docker Compose بالكامل والتأكد من استقرار Kafka و PostgreSQL و NiFi.
2. تشغيل تطبيق Spark Structured Streaming وتأكيد استماعه إلى `crashes.cleaned`.
3. تفعيل NiFi Flow في Process Group `Aircraft Accidents ETL`.
4. تشغيل Python Producer لبث عينة من 50 سجلاً من داتاسيت NTSB.
5. التحقق من وصول الرسائل كصفوف في جدول `accidents` بقاعدة بيانات PostgreSQL.

---

## 2. مصفوفة التحقق (Verification Matrix)
| المحطة | الاختبار المطلوب | النتيجة المتوقعة |
|---|---|---|
| **Producer** | إرسال 50 رسالة | 50 رسالة مرسلة بنجاح |
| **Kafka (`crashes.raw`)** | استهلاك الرسائل | 50 رسالة مسجلة بالـ Offsets |
| **NiFi Flow** | التحقق والفلترة | 50 FlowFiles صالحة تمر للمعالجة |
| **Kafka (`crashes.cleaned`)** | النشر بعد التنظيف | 50 رسالة نظيفة مطابقة للـ Contract |
| **Spark Streaming** | المعالجة عبر foreachBatch | معالجة الـ Micro-batch بدون أخطاء Schema |
| **PostgreSQL** | الاستعلام عبر SQL | `SELECT count(*) FROM accidents;` يرجع 50 صفاً |
| **Idempotency** | إعادة بث نفس السجلات | بقاء العدد 50 مع تحديث `updated_at` |
