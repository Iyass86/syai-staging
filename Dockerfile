# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# هذه المرحلة هي حيث يتم تثبيت Flutter وبناء مشروعك للويب.
# الهدف هو الحصول على ملفات الويب الجاهزة فقط.

# نستخدم صورة Debian خفيفة كنقطة بداية. يمكنك أيضاً استخدام صور Flutter الرسمية هنا.
FROM debian:stable-slim AS build-stage

# تحديث قائمة الحزم وتثبيت الأدوات الأساسية (curl, git, unzip) المطلوبة لتنزيل Flutter.
RUN apt-get update && apt-get install -y curl git unzip

# تعريف دليل العمل داخل الحاوية. كل الأوامر التالية ستُنفذ داخل /app.
WORKDIR /app

# استنساخ (Clone) مستودع Flutter SDK الرسمي.
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
# إضافة مسار Flutter إلى متغير البيئة PATH لكي يتمكن Docker من العثور على أوامر Flutter.
ENV PATH="/usr/local/flutter/bin:${PATH}"
# تحميل الأدوات والاعتمادات اللازمة لـ Flutter Web.
RUN flutter precache --web

# نسخ جميع ملفات مشروع Flutter الخاص بك من جهازك (أو مستودع Git) إلى داخل الحاوية في مجلد /app.
COPY . .

# بناء تطبيق Flutter للويب في وضع الإصدار (Release). هذا سينتج ملفات الويب في /app/build/web.
RUN flutter build web --release

# --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# هذه المرحلة تأخذ مخرجات البناء من المرحلة الأولى وتستخدم خادم ويب Nginx لتقديمها.
# الهدف هو صورة نهائية صغيرة تحتوي فقط على Nginx والملفات الثابتة.

# نبدأ من صورة Nginx رسمية خفيفة (مبنية على Alpine Linux).
FROM nginx:stable-alpine AS serve-stage

# إزالة ملفات إعدادات Nginx الافتراضية وملفات الويب الافتراضية.
# هذا يضمن أننا نستخدم إعداداتنا وملفاتنا الخاصة فقط.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملف إعدادات Nginx المخصص (nginx.conf) إلى مسار الإعدادات الافتراضي لـ Nginx.
# هذا الملف سيخبر Nginx كيف يتعامل مع تطبيق Flutter Web الخاص بنا.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# الأهم: نسخ ملفات Flutter Web المبنية من المرحلة الأولى (/app/build/web)
# إلى مجلد خدمة Nginx الافتراضي (/usr/share/nginx/html).
# لاحظ `COPY --from=build-stage` الذي يسمح لنا بالنسخ من مرحلة سابقة.
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80 (المنفذ الافتراضي لـ HTTP).
EXPOSE 80

# أمر التشغيل: بدء تشغيل Nginx في المقدمة.
# `daemon off;` يضمن أن Nginx يعمل في المقدمة، وهو أمر ضروري للحاويات.
CMD ["nginx", "-g", "daemon off;"]