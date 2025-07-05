# --- المرحلة الأولى: بناء تطبيق Flutter Web (Build Stage) ---
# يمكنك اختيار إحدى العلامات التالية:
# 1. إذا أردت أحدث إصدار مستقر من Flutter (مع Dart SDK >= 3.0.0):
    FROM cirrusci/flutter:latest AS build-stage

    # 2. إذا أردت إصدار Flutter محدد (مثلاً 3.19.6، والذي يستخدم Dart SDK 3.0.0 أو أعلى):
    # يمكنك استبدال 3.19.6 بالإصدار الدقيق الذي تحتاجه.
    # FROM cirrusci/flutter:3.19.6 AS build-stage
    
    # تعيين دليل العمل داخل الحاوية.
    WORKDIR /app
    
    # نسخ جميع ملفات المشروع من المضيف إلى دليل العمل داخل الحاوية.
    COPY . .
    
    # بناء تطبيق Flutter للويب في وضع الإصدار (Release).
    RUN flutter build web --release
    
    # --- المرحلة الثانية: خدمة الملفات المبنية باستخدام Nginx (Serve Stage) ---
    FROM nginx:stable-alpine AS serve-stage
    
    RUN rm -rf /etc/nginx/conf.d/* /usr/share/nginx/html/*
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    COPY --from=build-stage /app/build/web /usr/share/nginx/html
    
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]