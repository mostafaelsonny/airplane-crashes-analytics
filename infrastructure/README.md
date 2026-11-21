# ⚙️ Infrastructure & Docker Environment

المسؤول: **روان (Rovan)** | Infrastructure Engineer

---

## 🚀 تشغيل البيئة
```bash
# تشغيل جميع الخدمات في الخلفية
docker compose up -d

# إيقاف الخدمات
docker compose down

# إيقاف الخدمات مع حذف الـ Volumes (مسح البيانات)
docker compose down -v

# فحص سجلات كافكا
docker compose logs -f kafka
```

---

## 🌐 خريطة المنافذ والـ Listeners
* **Zookeeper:** `2181`
* **Kafka Internal:** `kafka:9092` (للتواصل بين حاويات Docker)
* **Kafka External:** `localhost:29092` (للتواصل من جهاز المطور / Windows Host)
* **PostgreSQL:** `localhost:5432`
* **Apache NiFi:** `https://localhost:8443/nifi`
