# شاشة إعداد بكسل سناب شات

## 📋 الوصف

شاشة بسيطة وأنيقة لإعداد بكسل سناب شات للعملاء. تتضمن:

- عرض كود الجافا سكربت مع Client ID
- زر نسخ الكود إلى الحافظة
- فحص حالة البكسل
- تصميم متناسق مع المشروع

## 🚀 كيفية الاستخدام

### 1. التنقل المباشر

```dart
import 'package:get/get.dart';
import '../routes/app_routes.dart';

// الانتقال إلى شاشة إعداد البكسل
Get.toNamed('${AppRoutes.snapPixelSetup}?clientId=your-client-id');
```

### 2. استخدام Widget الزر

```dart
import '../ui/widgets/snap_pixel_setup_button.dart';

// زر بسيط
SnapPixelSetupButton(clientId: 'your-client-id')

// زر موسع
SnapPixelSetupButton(
  clientId: 'your-client-id',
  isExpanded: true,
  customText: 'إعداد بكسل سناب شات',
)

// زر عائم
QuickSnapPixelButton(clientId: 'your-client-id')
```

### 3. استخدام الأمثلة الجاهزة

```dart
import '../examples/snap_pixel_usage_examples.dart';

// التنقل
SnapPixelUsageExamples.navigateToPixelSetup('your-client-id');

// Widget جاهز
SnapPixelUsageExamples.buildSimpleButton('your-client-id');
```

## 📱 صفحة الاختبار

```dart
import '../examples/snap_pixel_usage_examples.dart';

// عرض صفحة الاختبار
Get.to(() => const SnapPixelTestPage());
```

## 🔧 المميزات

- ✅ تصميم متناسق مع موضوع المشروع
- ✅ نسخ الكود بنقرة واحدة
- ✅ فحص حالة البكسل (محاكاة)
- ✅ رسائل تأكيد ونجاح
- ✅ تصميم متجاوب
- ✅ دعم اللغة العربية

## 🛠 التخصيص

يمكنك تخصيص:

- ألوان الواجهة
- نص الرسائل
- رابط API لفحص الحالة
- تصميم الأزرار

## 📂 الملفات

- `snap_pixel_setup_page.dart` - الشاشة الرئيسية
- `snap_pixel_setup_button.dart` - Widget الأزرار
- `snap_pixel_usage_examples.dart` - أمثلة الاستخدام
- `app_routes.dart` - المسارات
- `app_pages.dart` - تسجيل الصفحات

## 🔗 المسار

```
/snap-pixel-setup?clientId=your-client-id
```

---

**ملاحظة:** تأكد من تغيير رابط API في الكود للاستخدام الفعلي في الإنتاج.
