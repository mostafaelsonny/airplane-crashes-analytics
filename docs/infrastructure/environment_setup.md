# 🛠️ Environment Setup Guide
المسؤول: **روان (Rovan)** | Infrastructure Engineer

---

## 1. المتطلبات المسبقة (System Prerequisites)
* Docker Desktop 4.x+ مع تفعيل محرك WSL 2 على Windows.
* Python 3.11+.
* Java JDK 11 أو 17 (لتشغيل واختبار PySpark و Kafka محلياً).

---

## 2. تشغيل الخدمات عبر Docker Compose
```bash
docker compose -f infrastructure/docker-compose.yml up -d
```

## 3. التحقق من صحة الخدمات (Healthchecks)
* فحص حالة الحاويات: `docker ps`
* فحص اتصال الـ Broker: `docker exec -it kafka kafka-broker-api-versions --bootstrap-server localhost:9092`
* فحص PostgreSQL: `docker exec -it postgres pg_isready -U postgres`
