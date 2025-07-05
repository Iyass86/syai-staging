# --- خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# نبدأ من صورة Nginx رسمية خفيفة الوزن ومناسبة لخدمة الملفات الثابتة.
FROM nginx:stable-alpine

# إزالة ملفات إعدادات Nginx الافتراضية وأي محتوى افتراضي.
# هذا يضمن أننا سنستخدم فقط إعداداتنا ومحتوانا الخاص.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملف إعدادات Nginx المخصص (nginx.conf) إلى مسار الإعدادات الافتراضي لـ Nginx.
# يجب أن يكون هذا الملف موجودًا في الجذر الرئيسي لمشروعك أيضاً.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# نسخ ملفات Flutter Web المبنية مسبقاً من مجلد build/web المحلي
# إلى مجلد خدمة Nginx الافتراضي (/usr/share/nginx/html).
COPY build/web /usr/share/nginx/html

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80 (المنفذ القياسي لـ HTTP).
EXPOSE 80

# الأمر الافتراضي الذي سيتم تنفيذه عند بدء تشغيل الحاوية.
# يبدأ هذا الأمر خادم Nginx ويجعله يعمل في المقدمة، وهو ضروري لـ Docker.
CMD ["nginx", "-g", "daemon off;"]