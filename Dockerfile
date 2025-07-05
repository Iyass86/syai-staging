# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# نستخدم صورة instrumentisto/flutter بالإصدار 3.22.0.
# هذا الإصدار من Flutter يستخدم Dart SDK الذي يقع ضمن نطاق 3.0.0 - 4.0.0.
# تأكد من أن هذا الإصدار يلبي متطلبات مشروعك.
FROM instrumentisto/flutter:3.29.3 AS build-stage

# تعيين دليل العمل داخل الحاوية. كل الأوامر التالية ستُنفذ هنا.
# هذا المسار (root) هو أفضل مكان لوضع ملفات مشروعك.
WORKDIR /app

# نسخ جميع ملفات المشروع من المضيف (جهازك أو مستودع Git) إلى دليل العمل داخل الحاوية.
# هذا يشمل الكود المصدري، pubspec.yaml، وأي أصول أخرى.
COPY . .

# بناء تطبيق Flutter للويب في وضع الإصدار (Release).
# يتم تشغيل هذا الأمر بواسطة Flutter SDK المثبت مسبقًا في الصورة الأساسية (instrumentisto/flutter).
# الملفات الناتجة ستكون في مجلد /app/build/web.
RUN flutter build web --release

# --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# نبدأ من صورة Nginx رسمية خفيفة الوزن ومناسبة لخدمة الملفات الثابتة.
FROM nginx:stable-alpine AS serve-stage

# إزالة ملفات إعدادات Nginx الافتراضية وأي محتوى افتراضي.
# هذا يضمن أننا سنستخدم فقط إعداداتنا ومحتوانا الخاص.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملف إعدادات Nginx المخصص (nginx.conf) إلى مسار الإعدادات الافتراضي لـ Nginx.
# يجب أن يكون هذا الملف موجودًا في الجذر الرئيسي لمشروعك أيضاً.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# نسخ ملفات Flutter Web المبنية من المرحلة الأولى (build-stage)
# إلى مجلد خدمة Nginx الافتراضي (/usr/share/nginx/html).
# هذا هو المكان الذي سيقوم Nginx بخدمة المحتوى منه.
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80 (المنفذ القياسي لـ HTTP).
EXPOSE 80

# الأمر الافتراضي الذي سيتم تنفيذه عند بدء تشغيل الحاوية.
# يبدأ هذا الأمر خادم Nginx ويجعله يعمل في المقدمة، وهو ضروري لـ Docker.
CMD ["nginx", "-g", "daemon off;"]