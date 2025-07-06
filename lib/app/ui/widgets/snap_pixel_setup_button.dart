import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

/// Widget بسيط لعرض زر الوصول إلى شاشة إعداد بكسل سناب شات
class SnapPixelSetupButton extends StatelessWidget {
  final String clientId;
  final bool isExpanded;
  final IconData? icon;
  final String? customText;

  const SnapPixelSetupButton({
    super.key,
    required this.clientId,
    this.isExpanded = false,
    this.icon,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return Card(
        child: ListTile(
          leading: Icon(icon ?? Icons.analytics),
          title: Text(customText ?? 'إعداد بكسل سناب شات'),
          subtitle: const Text('إعداد وفحص حالة البكسل'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _navigateToPixelSetup(),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _navigateToPixelSetup(),
      icon: Icon(icon ?? Icons.analytics),
      label: Text(customText ?? 'إعداد بكسل سناب شات'),
    );
  }

  void _navigateToPixelSetup() {
    Get.toNamed('${AppRoutes.snapPixelSetup}?clientId=$clientId');
  }
}

/// Widget مبسط لاستخدام سريع
class QuickSnapPixelButton extends StatelessWidget {
  final String clientId;

  const QuickSnapPixelButton({
    super.key,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.toNamed('${AppRoutes.snapPixelSetup}?clientId=$clientId');
      },
      icon: const Icon(Icons.code),
      label: const Text('بكسل سناب شات'),
      backgroundColor: Colors.yellow[700],
      foregroundColor: Colors.black,
    );
  }
}
