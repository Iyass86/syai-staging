#!/bin/bash

# سكريبت لبناء ونشر تطبيق Flutter Web بشكل محسن

echo "🚀 بدء بناء تطبيق Flutter Web..."

# تنظيف البناء السابق
echo "🧹 تنظيف البناء السابق..."
flutter clean

# تحميل التبعيات
echo "📦 تحميل التبعيات..."
flutter pub get

# بناء التطبيق للويب
echo "🏗️ بناء التطبيق للويب..."
flutter build web --release --tree-shake-icons --dart-define=FLUTTER_WEB_USE_SKIA=true

# بناء Docker image
echo "🐳 بناء Docker image..."
docker build -t syai-flutter-web:latest .

# تشغيل الحاوية
echo "▶️ تشغيل الحاوية..."
docker-compose up -d

echo "✅ تم بناء ونشر التطبيق بنجاح!"
echo "🌐 يمكنك الآن الوصول للتطبيق على: http://localhost"
