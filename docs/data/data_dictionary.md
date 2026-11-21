# 📚 Data Dictionary — قاموس بيانات حوادث الطيران
المسؤول: **روني (Rony)** | Data Engineer

يحتوي هذا المستند على التوصيف المفصل لحقول داتاسيت NTSB وقواعد بيانات Access وعلاقتها بجداول المشروع.

| الحقل | الوصف | المصدر في NTSB Access |
|---|---|---|
| `event_id` | المعرف الفريد للحادث | `events.ev_id` |
| `event_date` | تاريخ وقوع الحادث | `events.ev_date` |
| `event_time` | وقت وقوع الحادث | `events.ev_time` |
| `country` | الدولة | `events.ev_country` |
| `location` | موقع الحادث أو المدينة | `events.ev_city` / `events.ev_state` |
| `latitude` | خط العرض الجغرافي | `events.latitude` |
| `longitude` | خط الطول الجغرافي | `events.longitude` |
| `aircraft_make` | الشركة المصنعة للطائرة | `aircraft.acft_make` |
| `aircraft_model` | طراز الطائرة | `aircraft.acft_model` |
| `injury_severity`| تصنيف خطورة الإصابات | `events.inj_tot_f` / `events.ev_highest_injury` |
| `fatal_injuries` | إجمالي الوفيات | `injury.fatal` |
| `serious_injuries`| إجمالي الإصابات البليغة | `injury.serious` |
| `minor_injuries` | إجمالي الإصابات الطفيفة | `injury.minor` |
