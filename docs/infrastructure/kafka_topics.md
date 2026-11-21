# 📨 Kafka Topics Configuration
المسؤول: **روان (Rovan)** | Infrastructure Engineer

---

## 1. تفاصيل المواضيع (Topics)
* `crashes.raw`: يستقبل السجلات الخام من بايثون Producer (3 Partitions, Replication: 1).
* `crashes.cleaned`: يستقبل السجلات المنظفة والمفلترة من Apache NiFi (3 Partitions, Replication: 1).
* `crashes.dlq`: مسار عزل الرسائل غير الصالحة وتالفة البيانات (1 Partition, Replication: 1).

---

## 2. أوامر الإنشاء والفحص
```bash
# إنشاء crashes.raw
docker exec -it kafka kafka-topics --create --bootstrap-server localhost:9092 --topic crashes.raw --partitions 3 --replication-factor 1

# إنشاء crashes.cleaned
docker exec -it kafka kafka-topics --create --bootstrap-server localhost:9092 --topic crashes.cleaned --partitions 3 --replication-factor 1

# إنشاء crashes.dlq
docker exec -it kafka kafka-topics --create --bootstrap-server localhost:9092 --topic crashes.dlq --partitions 1 --replication-factor 1
```
