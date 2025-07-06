# 🎯 ميزة عرض Pixels لحسابات Snapchat الإعلانية

## 📋 الوصف

تم إضافة ميزة جديدة تتيح للمستخدمين عرض وإدارة Pixels الخاصة بكل حساب إعلانات Snapchat. هذه الميزة تشمل:

- عرض قائمة جميع الـ pixels الخاصة بحساب إعلانات محدد
- نسخ كود JavaScript للـ pixel
- الانتقال إلى شاشة إعداد البكسل
- واجهة مستخدم أنيقة ومتجاوبة

## ✨ المميزات

### 🔍 عرض Pixels

- قائمة تفصيلية بجميع الـ pixels
- عرض حالة كل pixel (نشط/غير نشط)
- معلومات تفصيلية لكل pixel (تاريخ الإنشاء، ID، الحالة)

### 📋 نسخ الكود

- إمكانية نسخ كود JavaScript للـ pixel بنقرة واحدة
- رسائل تأكيد نجاح النسخ
- Haptic feedback للتفاعل الأفضل

### ⚙️ إعداد Pixels

- الانتقال المباشر إلى شاشة إعداد البكسل
- ربط سلس مع الميزات الموجودة

### 🎨 واجهة المستخدم

- تصميم متجاوب للجوال والسطح المكتبي
- رسوم متحركة سلسة
- دعم الوضع الفاتح والداكن
- ترجمة كاملة للعربية والإنجليزية

## 🚀 كيفية الوصول

### من صفحة حسابات الإعلانات:

1. انتقل إلى صفحة "Ad Accounts"
2. اختر الحساب المطلوب
3. انقر على أيقونة Analytics 📊 بجانب الحساب
4. ستنتقل إلى صفحة عرض Pixels الخاصة بهذا الحساب

### مباشرة عبر URL:

```
/snap-pixels?adAccountId=ACCOUNT_ID&adAccountName=ACCOUNT_NAME
```

## 🛠 الملفات المضافة/المحدثة

### ملفات جديدة:

```
lib/app/
├── data/models/
│   └── pixel.dart                           # نموذج بيانات الـ pixel
├── controllers/snap_controllers/
│   └── snap_pixels_controller.dart          # تحكم في الـ pixels
├── ui/pages/
│   └── snap_pixels_page.dart                # صفحة عرض الـ pixels
└── bindings/
    └── snap_pixels_binding.dart             # ربط التبعيات
```

### ملفات محدثة:

```
lib/app/
├── repositories/
│   └── snap_repository.dart                 # إضافة API للـ pixels
├── routes/
│   ├── app_routes.dart                      # إضافة مسار الـ pixels
│   └── app_pages.dart                       # تسجيل صفحة الـ pixels
├── ui/pages/
│   └── snap_accounts_page.dart              # إضافة أيقونة الـ pixels
└── translations/
    └── app_translations.dart                # إضافة ترجمات الـ pixels
```

## 🔧 التقنيات المستخدمة

### API Integration:

- **Endpoint**: `https://adsapi.snapchat.com/v1/adaccounts/{ad_account_id}/pixels`
- **Method**: GET
- **Headers**: Authorization Bearer Token
- **Response**: JSON مع قائمة الـ pixels

### State Management:

- **GetX**: لإدارة الحالة والتنقل
- **Reactive Programming**: استخدام Rx للتحديثات الفورية
- **Error Handling**: معالجة شاملة للأخطاء

### UI/UX:

- **Material Design 3**: تصميم حديث ومتسق
- **Responsive Design**: متجاوب مع جميع أحجام الشاشات
- **Animations**: رسوم متحركة سلسة للتفاعل
- **Internationalization**: دعم متعدد اللغات

## 📡 API Response Structure

```json
{
  "request_status": "SUCCESS",
  "request_id": "request_id_here",
  "pixels": [
    {
      "sub_request_status": "SUCCESS",
      "pixel": {
        "id": "pixel_id_here",
        "updated_at": "2017-03-15T18:19:08.576Z",
        "created_at": "2017-03-15T18:19:08.576Z",
        "effective_status": "ACTIVE",
        "name": "Test pixel",
        "ad_account_id": "ad_account_id_here",
        "status": "ACTIVE",
        "pixel_javascript": "<!-- Snap Pixel Code -->..."
      }
    }
  ]
}
```

## 🎯 User Journey

1. **المستخدم في صفحة Ad Accounts**
2. **يرى أيقونة Analytics بجانب كل حساب**
3. **ينقر على الأيقونة**
4. **ينتقل إلى صفحة Pixels الخاصة بالحساب**
5. **يرى قائمة بجميع الـ pixels**
6. **يمكنه نسخ كود أي pixel**
7. **يمكنه الانتقال إلى إعداد البكسل**

## 🔒 أمان البيانات

- **Token-based Authentication**: استخدام Bearer Token
- **Error Handling**: معالجة آمنة للأخطاء
- **Data Validation**: التحقق من صحة البيانات
- **Privacy**: عدم تخزين معلومات حساسة محلياً

## 🚦 معالجة الأخطاء

### أخطاء الشبكة:

- رسائل واضحة للمستخدم
- إمكانية إعادة المحاولة
- تتبع حالة التحميل

### أخطاء API:

- عرض رسائل الخطأ من الخادم
- معالجة حالات 401, 403, 429
- Fallback للحالات غير المتوقعة

### أخطاء التطبيق:

- تسجيل تفصيلي للأخطاء
- استعادة graceful للحالة
- منع crash التطبيق

## 🎨 تصميم UI

### الألوان:

- **Primary**: ألوان Snapchat الأصلية
- **Status Colors**: أخضر للنشط، برتقالي للتحذير
- **Surface Colors**: متوافقة مع الثيم

### التخطيط:

- **Cards**: كل pixel في بطاقة منفصلة
- **List View**: عرض قائمة قابلة للتمرير
- **Action Buttons**: أزرار واضحة للإجراءات

### الرسوم المتحركة:

- **Fade In**: دخول سلس للعناصر
- **Loading States**: مؤشرات تحميل أنيقة
- **Haptic Feedback**: ردود فعل لمسية

## 🌍 الترجمة

### الإنجليزية:

- Pixels
- View Pixels
- Copy Pixel Code
- Pixel Setup
- No pixels found
- Loading pixels...

### العربية:

- البكسلز
- عرض البكسلز
- نسخ كود البكسل
- إعداد البكسل
- لم يتم العثور على بكسلز
- جاري تحميل البكسلز...

## 🔮 التطوير المستقبلي

### ميزات مقترحة:

- **إنشاء Pixels جديدة**: إضافة إمكانية إنشاء pixels
- **تحرير Pixels**: تعديل إعدادات الـ pixels الموجودة
- **إحصائيات Pixels**: عرض بيانات الأداء
- **تصدير البيانات**: تصدير معلومات الـ pixels

### تحسينات تقنية:

- **Caching**: تخزين مؤقت للبيانات
- **Offline Support**: دعم العمل بدون اتصال
- **Real-time Updates**: تحديثات فورية
- **Advanced Filtering**: فلترة متقدمة للـ pixels

---

## 📞 الدعم

في حالة وجود أي مشاكل أو اقتراحات، يرجى:

1. التأكد من صحة التوكن
2. التحقق من صلاحيات الحساب
3. مراجعة logs التطبيق
4. التواصل مع فريق التطوير

---

**ملاحظة**: هذه الميزة تتطلب صلاحيات قراءة Snapchat Marketing API والوصول إلى حسابات الإعلانات.
