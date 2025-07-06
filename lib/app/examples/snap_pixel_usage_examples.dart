import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/widgets/snap_pixel_setup_button.dart';
import '../routes/app_routes.dart';

/// أمثلة على كيفية استخدام شاشة إعداد بكسل سناب شات
class SnapPixelUsageExamples {
  /// 1. التنقل المباشر بـ clientId
  static void navigateToPixelSetup(String clientId) {
    Get.toNamed('${AppRoutes.snapPixelSetup}?clientId=$clientId');
  }

  /// 2. استخدام Widget الزر البسيط
  static Widget buildSimpleButton(String clientId) {
    return SnapPixelSetupButton(clientId: clientId);
  }

  /// 3. استخدام Widget الزر الموسع
  static Widget buildExpandedButton(String clientId) {
    return SnapPixelSetupButton(
      clientId: clientId,
      isExpanded: true,
      customText: 'إعداد بكسل سناب شات للعميل',
    );
  }

  /// 4. استخدام Floating Action Button
  static Widget buildFloatingButton(String clientId) {
    return QuickSnapPixelButton(clientId: clientId);
  }

  /// 5. مثال على صفحة تحتوي على الزر
  static Widget buildExamplePage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مثال على استخدام بكسل سناب شات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'اختر طريقة الوصول إلى شاشة إعداد بكسل سناب شات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // زر بسيط
            buildSimpleButton('test-client-123'),
            const SizedBox(height: 16),

            // زر موسع
            buildExpandedButton('test-client-456'),
            const SizedBox(height: 16),

            // زر مخصص
            ElevatedButton(
              onPressed: () => navigateToPixelSetup('custom-client-789'),
              child: const Text('إعداد بكسل مخصص'),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingButton('floating-client-000'),
    );
  }
}

/// مثال على شاشة اختبار كاملة
class SnapPixelTestPage extends StatelessWidget {
  const SnapPixelTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SnapPixelUsageExamples.buildExamplePage();
  }
}
