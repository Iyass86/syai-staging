# سكريبت PowerShell لبناء ونشر تطبيق Flutter Web

Write-Host "🚀 بدء بناء تطبيق Flutter Web..." -ForegroundColor Green

# تنظيف البناء السابق
Write-Host "🧹 تنظيف البناء السابق..." -ForegroundColor Yellow
flutter clean

# تحميل التبعيات
Write-Host "📦 تحميل التبعيات..." -ForegroundColor Yellow
flutter pub get

# بناء التطبيق للويب
Write-Host "🏗️ بناء التطبيق للويب..." -ForegroundColor Yellow
flutter build web --release --tree-shake-icons --dart-define=FLUTTER_WEB_USE_SKIA=true

# بناء Docker image
Write-Host "🐳 بناء Docker image..." -ForegroundColor Yellow
docker build -t syai-flutter-web:latest .

# تشغيل الحاوية
Write-Host "▶️ تشغيل الحاوية..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "✅ تم بناء ونشر التطبيق بنجاح!" -ForegroundColor Green
Write-Host "🌐 يمكنك الآن الوصول للتطبيق على: http://localhost" -ForegroundColor Cyan
