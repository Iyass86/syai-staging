# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# نستخدم صورة instrumentisto/flutter بالإصدار 3.29.3
# هذا الإصدار من Flutter يستخدم Dart SDK الذي يقع ضمن نطاق 3.0.0 - 4.0.0.
# تأكد من أن هذا الإصدار يلبي متطلبات مشروعك.
FROM instrumentisto/flutter:3.29.3 AS build-stage

# تعيين دليل العمل داخل الحاوية. كل الأوامر التالية ستُنفذ هنا.
WORKDIR /app

# نسخ ملفات التكوين أولاً للاستفادة من Docker cache
# هذا يسمح بإعادة استخدام cache إذا لم تتغير التبعيات
COPY pubspec.yaml pubspec.lock ./

# تحميل التبعيات في طبقة منفصلة للاستفادة من cache
RUN flutter pub get

# نسخ ملف البيئة المطلوب (مع التحقق من وجوده)
COPY .env* ./
RUN test -f .env || echo "SUPABASE_URL=\nSUPABASE_ANON_KEY=\nWEBHOOK_URL=\nOAUTH_CLIENT_ID=\nOAUTH_REDIRECT_URI=\nAPI_BASE_URL=" > .env

# نسخ الكود المصدري بعد تحميل التبعيات
COPY lib/ ./lib/
COPY web/ ./web/
COPY analysis_options.yaml ./

# بناء تطبيق Flutter للويب في وضع الإصدار مع تحسينات الأداء
# استخدام --tree-shake-icons لتقليل حجم الملفات
RUN flutter build web --release --tree-shake-icons --dart-define=FLUTTER_WEB_USE_SKIA=true

# --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
# نبدأ من صورة Nginx رسمية خفيفة الوزن ومناسبة لخدمة الملفات الثابتة.
FROM nginx:stable-alpine AS serve-stage

# تثبيت أدوات ضرورية لضغط الملفات
RUN apk add --no-cache gzip

# إزالة ملفات إعدادات Nginx الافتراضية وأي محتوى افتراضي.
RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*

# نسخ ملفات Flutter Web المبنية من المرحلة الأولى
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# ضغط الملفات الثابتة مسبقاً لتحسين الأداء
RUN find /usr/share/nginx/html -type f \( -name "*.js" -o -name "*.css" -o -name "*.html" -o -name "*.json" \) -exec gzip -9 -k {} \;

# نسخ ملف إعدادات Nginx المحسن
COPY nginx.conf /etc/nginx/conf.d/default.conf

# إعلام Docker بأن الحاوية ستستمع على المنفذ 80
EXPOSE 80

# تشغيل Nginx مع إعدادات محسنة
CMD ["nginx", "-g", "daemon off;"]