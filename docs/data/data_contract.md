# 📜 Unified Data Contract — العقد الموحد للبيانات
### Real-Time Airplane Crashes Analytics

> **المسؤولون عن الصياغة:** منذر (Database Engineer) + روني (Data Engineer) + مصطفى (Team Leader)  
> **الحالة:** معتمد وملزم لجميع أعضاء الـ Pipeline (Producer, NiFi, Spark, PostgreSQL).

---

## 1. نموذج السجل القياسي (Standard JSON Event Schema)

كل رسالة يتم بثها في المنظومة (سواء في `crashes.raw` أو `crashes.cleaned`) يجب أن تطابق هذا الهيكل بالكامل:

```json
{
  "event_id": "ACC-2024-00123",
  "event_date": "2024-03-15",
  "event_time": "14:30:00",
  "country": "United States",
  "location": "Los Angeles, CA",
  "latitude": 34.0522,
  "longitude": -118.2437,
  "aircraft_make": "Boeing",
  "aircraft_model": "737-800",
  "injury_severity": "Non-Fatal",
  "fatal_injuries": 0,
  "serious_injuries": 1,
  "minor_injuries": 2
}
```

---

## 2. جدول مواصفات الحقول وقواعد التحقق (Field Specifications)

| الحقل (Field) | النوع (Data Type) | إلزامي؟ | القيود والقواعد (Validation Rules) |
|---|---|---|---|
| `event_id` | `String` | **نعم (PK)** | المعرف الفريد للحادث. لا يقبل فارغاً أو Null. |
| `event_date` | `String (Date)` | **نعم** | صيغة ISO 8601: `YYYY-MM-DD`. |
| `event_time` | `String (Time)` | لا | صيغة `HH:MM:SS` (يقبل Null إذا لم يتوفر). |
| `country` | `String` | **نعم** | اسم الدولة (الحد الأقصى 100 حرف). |
| `location` | `String` | لا | نص وصفي لمكان الحادث أو المدينة. |
| `latitude` | `Float / Double` | لا | قيمة بين `-90.0` و `90.0` (يقبل Null). |
| `longitude` | `Float / Double` | لا | قيمة بين `-180.0` و `180.0` (يقبل Null). |
| `aircraft_make` | `String` | لا | الشركة المصنعة للطائرة (Trim للمسافات الزائدة). |
| `aircraft_model` | `String` | لا | طراز الطائرة. |
| `injury_severity`| `String` | لا | تصنيف الخطورة: `Fatal`, `Non-Fatal`, `Incident`. |
| `fatal_injuries` | `Integer` | لا | عدد الوفيات `>= 0`. القيمة الافتراضية `0`. |
| `serious_injuries`| `Integer` | لا | الإصابات البليغة `>= 0`. القيمة الافتراضية `0`. |
| `minor_injuries` | `Integer` | لا | الإصابات الطفيفة `>= 0`. القيمة الافتراضية `0`. |

---

## 3. قواعد الـ DLQ ومعالجة السجلات المشوهة (Invalid Records)
إذا افتقر السجل لأي من الحقول الإلزامية (`event_id` أو `event_date` أو `country`) أو كان الـ JSON تالفاً:
1. يقوم Apache NiFi فوراً بتوجيهه إلى Topic: `crashes.dlq`.
2. يُمنع منعاً باتاً تمريره إلى `crashes.cleaned` لحماية محرك Spark وقاعدة البيانات من التوقف.
