import 'package:get/get.dart';

class TypewriterStateController extends GetxController {
  // تتبع آخر رسالة تم عرضها بتأثير الكتابة
  final RxString lastTypedMessageId = ''.obs;

  // تحديد ما إذا كان يجب إظهار تأثير الكتابة لرسالة معينة
  bool shouldShowTypewriterEffect(String messageId, bool isLastAiMessage) {
    if (!isLastAiMessage) return false;

    // إذا كانت هذه رسالة جديدة (لم يتم كتابتها من قبل)
    if (lastTypedMessageId.value != messageId) {
      lastTypedMessageId.value = messageId;
      return true;
    }

    return false;
  }

  // إعادة تعيين الحالة
  void reset() {
    lastTypedMessageId.value = '';
  }
}
