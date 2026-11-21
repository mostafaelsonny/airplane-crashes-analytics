# 🛡️ GitHub Rulesets — قواعد حماية الفروع الصارمة

الملفان `protect-main.json` و `protect-develop.json` يطبقان القواعد الصارمة التي طلبها قائد الفريق (Mostafa) لحماية المستودع وضمان جودة الكود:

---

## 🔒 ملخص القواعد المفروضة

| الميزة / الإعداد | فرع `main` | فرع `develop` | الشرح |
|---|---|---|---|
| **Enforcement Status** | `Active` | `Active` | القواعد مفعلة وإلزامية على الجميع. |
| **Require Pull Request** | **ON** | **ON** | ممنوع تماماً الرفع المباشر (Direct Push). كله يمر عبر PR. |
| **Required Approvals** | **1 (Mostafa)** | **1 (Mostafa)** | لا يمكن دمج الـ PR إلا بموافقة مصطفى. |
| **Require Code Owner Review** | **ON** | **ON** | مراجعة المالك المسجل في `CODEOWNERS` إلزامية (@mostafaelsonny). |
| **Dismiss Stale Approvals** | **ON** | **ON** | أي Commit جديد يُلغي الموافقة السابقة لإعادة الفحص. |
| **Require Conversation Resolution** | **ON** | **ON** | لا يمكن الدمج إلا بعد الرد وحل كل الملاحظات والتعليقات. |
| **Block Force Pushing (`--force`)** | **ON** | **ON** | يمنع مسح أو تعديل الـ History. |
| **Restrict Branch Deletion** | **ON** | **ON** | حماية الفروع الأساسية من الحذف العرضي. |
| **Bypass List** | **Admin فقط (Mostafa)** | **Admin فقط (Mostafa)** | فقط مصطفى هو من يملك صلاحية المراجعة والدمج النهائي. |

---

## 🛠️ كيفية تطبيق القواعد على GitHub

### الطريقة الأولى: من خلال المتصفح (Web UI)
1. ادخل إلى المستودع على GitHub: `https://github.com/mostafaelsonny/airplane-crashes-analytics`.
2. اذهب إلى: **Settings** -> **Rules** -> **Rulesets**.
3. اضغط **New ruleset** ثم اختر **Import a ruleset**.
4. ارفع ملف `.github/rulesets/protect-main.json` وتأكد من أن **Enforcement: Active** ثم اضغط **Save changes**.
5. كرر نفس الخطوة مع ملف `.github/rulesets/protect-develop.json`.

### الطريقة الثانية: عبر GitHub CLI (آلياً)
```bash
gh api -X POST "repos/{owner}/{repo}/rulesets" --input ".github/rulesets/protect-main.json"
gh api -X POST "repos/{owner}/{repo}/rulesets" --input ".github/rulesets/protect-develop.json"
```

---

## ⚠️ تنبيهات للأعضاء
* **الأعضاء بصلاحية Write:** مسموح لهم فقط بإنشاء فروع ميزات (`feature/*`) ورفع الـ PRs على `develop`.
* **الدمج إلى `main`:** يتم فقط في نهاية كل Sprint بعد إجراء الـ Sprint Review وموافقة الـ Team Leader.
