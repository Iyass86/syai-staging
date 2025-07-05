# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# نستخدم الصورة الرسمية لـ Cirrus CI الخاصة بـ Flutter.
# هذه الصورة تأتي مع Flutter SDK مثبتًا وجاهزًا للاستخدام،
# مما يحل مشكلة "flutter: not found" وتبسيط عملية البناء.
FROM cirrusci/flutter AS build-stage

# تعيين دليل العمل داخل الحاوية. كل الأوامر التالية ستُنفذ هنا.
# ملاحظة: بعض صور cirrusci/flutter قد تضع المشروع في /home/cirrus.
# ولكن WorkDir /app هو ممارسة جيدة ومتوافقة.
# ولكن WorkDir /app هو ممارسة جيدة ومتوافقة.
WORKDIR /app

# نسخ جميع ملفات المشروع من المضيف إلى دليل العمل داخل الحاوية.
# هذا يشمل الكود المصدري، pubspec.yaml، وأي أصول أخرى.
COPY . .

# بناء تطبيق Flutter للويب في وضع الإصدار (Release).
# يتم تشغيل هذا الأمر بواسطة Flutter SDK المثبت مسبقًا في الصورة الأساسية.
# الملفات الناتجة ستكون في /app/build/web.
RUN flutter build web --release

# --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# نبدأ من صورة Nginx رسمية خفيفة الوزن ومناسبة لخدمة الملفات الثابتة.
FROM nginx:stable-alpine AS serve-stage

# إزالة ملفات إعدادات Nginx الافتراضية وأي محتوى افتراضي.
# هذا يضمن استخدام إعداداتنا ومحتوانا الخاص فقط.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملف إعدادات Nginx المخصص (nginx.conf) إلى مسار الإعدادات الافتراضي لـ Nginx.
# تأكد أن هذا الملف موجود في جذر مشروعك أيضاً.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# نسخ ملفات Flutter Web المبنية من المرحلة الأولى (build-stage)
# إلى مجلد خدمة Nginx الافتراضي (/usr/share/nginx/html).
# هذا هو المكان الذي سيقوم Nginx بخدمة المحتوى منه.
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80.
EXPOSE 80

# الأمر الافتراضي الذي سيتم تنفيذه عند بدء تشغيل الحاوية.
# يبدأ هذا الأمر خادم Nginx ويجعله يعمل في المقدمة.
CMD ["nginx", "-g", "daemon off;"]