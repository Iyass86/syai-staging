# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# نستخدم الصورة الرسمية لـ Dart والتي تشمل Flutter SDK.
# هذا يتجنب الحاجة لتثبيت Git أو Flutter يدوياً، ويحل مشاكل مثل "flutter precache --web".
FROM dart:stable AS build-stage

# تعيين دليل العمل داخل الحاوية. كل الأوامر التالية ستُنفذ هنا.
WORKDIR /app

# نسخ ملفات المشروع إلى داخل الحاوية.
# سيتم نسخ جميع الملفات من جذر مشروعك على جهازك (أو المستودع) إلى /app داخل الحاوية.
COPY . .

# بناء تطبيق Flutter للويب في وضع الإصدار (Release).
# يتم تشغيل هذا الأمر بواسطة Flutter SDK المثبت مسبقًا في الصورة الأساسية (dart:stable).
# الملفات الناتجة ستكون في /app/build/web.
RUN flutter build web --release

# --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# نبدأ من صورة Nginx رسمية خفيفة الوزن ومناسبة لخدمة الملفات الثابتة.
FROM nginx:stable-alpine AS serve-stage

# إزالة ملفات إعدادات Nginx الافتراضية وأي محتوى افتراضي من مجلد الويب.
# هذا يضمن أننا سنستخدم فقط إعداداتنا ومحتوانا الخاص.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملف إعدادات Nginx المخصص (nginx.conf) إلى مسار الإعدادات الافتراضي لـ Nginx.
# يجب أن يكون لديك هذا الملف في جذر مشروعك أيضاً.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# الأهم: نسخ ملفات Flutter Web المبنية من المرحلة الأولى (build-stage)
# إلى مجلد خدمة Nginx الافتراضي.
# لاحظ استخدام `--from=build-stage` لجلب المخرجات من المرحلة السابقة.
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80 (المنفذ القياسي لـ HTTP).
EXPOSE 80

# الأمر الافتراضي الذي سيتم تنفيذه عند بدء تشغيل الحاوية.
# هذا يبدأ خادم Nginx ويجعله يعمل في المقدمة، وهو ضروري لـ Docker.
CMD ["nginx", "-g", "daemon off;"]