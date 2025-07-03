import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

/// Simple widget to show guest status in app bar
class GuestStatusIndicator extends StatelessWidget {
  const GuestStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (!authController.isGuest) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 16,
              color: Colors.orange.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'Guest',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.register),
              child: Icon(
                Icons.upgrade,
                size: 16,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Simple badge widget for guest users
class GuestBadge extends StatelessWidget {
  const GuestBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (!authController.isGuest) {
        return const SizedBox.shrink();
      }

      return Tooltip(
        message: 'Guest Account - Limited Features',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'GUEST',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    });
  }
}
