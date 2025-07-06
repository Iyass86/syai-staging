import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_display_controller.dart';
import '../widgets/message_display_container.dart';

class ErrorTestPage extends StatelessWidget {
  const ErrorTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final messageController = Get.find<MessageDisplayController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار عرض الأخطاء'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: MessageDisplayContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'اختبار النظام الجديد لعرض الأخطاء',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  messageController.displayError(
                    'هذا مثال على رسالة خطأ في أعلى الشاشة',
                    duration: const Duration(seconds: 5),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('عرض رسالة خطأ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  messageController.displaySuccess(
                    'تمت العملية بنجاح! هذا مثال على رسالة النجاح',
                    duration: const Duration(seconds: 5),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('عرض رسالة نجاح'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  messageController.displayNetworkError(
                    'فشل الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت',
                    duration: const Duration(seconds: 8),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('عرض خطأ الشبكة'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  messageController.hideAll();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('إخفاء جميع الرسائل'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
