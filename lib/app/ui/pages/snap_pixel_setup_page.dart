import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class SnapPixelSetupPage extends StatefulWidget {
  final String clientId;

  const SnapPixelSetupPage({
    super.key,
    required this.clientId,
  });

  @override
  State<SnapPixelSetupPage> createState() => _SnapPixelSetupPageState();
}

class _SnapPixelSetupPageState extends State<SnapPixelSetupPage> {
  bool isLoading = false;
  bool? isPixelActive;
  String? statusMessage;
  late String javascriptCode;

  @override
  void initState() {
    super.initState();
    javascriptCode = _generateJavaScriptCode(widget.clientId);
  }

  String _generateJavaScriptCode(String clientId) {
    return '''<!-- Snap Pixel Code -->
<script type='text/javascript'>
(function(e,t,n){if(e.snaptr)return;var a=e.snaptr=function()
{a.handleRequest?a.handleRequest.apply(a,arguments):a.queue.push(arguments)};
a.queue=[];var s='script';r=t.createElement(s);r.async=!0;
r.src=n;var u=t.getElementsByTagName(s)[0];
u.parentNode.insertBefore(r,u);})(window,document,
'https://sc-static.net/scevent.min.js');

snaptr('init', '$clientId', {
  'user_email': '__INSERT_USER_EMAIL__'
});

snaptr('track', 'PAGE_VIEW');
</script>
<!-- End Snap Pixel Code -->''';
  }

  Future<void> _copyCodeToClipboard() async {
    try {
      await Clipboard.setData(ClipboardData(text: javascriptCode));
      Get.snackbar(
        '✅ تم النسخ بنجاح',
        'تم نسخ كود البكسل إلى الحافظة بنجاح',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        ),
        shouldIconPulse: false,
        boxShadows: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );
    } catch (e) {
      Get.snackbar(
        '❌ خطأ في النسخ',
        'حدث خطأ أثناء نسخ الكود، حاول مرة أخرى',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, color: Colors.white, size: 20),
        ),
        shouldIconPulse: false,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );
    }
  }

  Future<void> _checkPixelStatus() async {
    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();

    setState(() {
      isLoading = true;
      isPixelActive = null;
      statusMessage = null;
    });

    try {
      final dio = Dio();
      dio.options.receiveTimeout = const Duration(seconds: 10);
      dio.options.connectTimeout = const Duration(seconds: 10);

      // محاكاة طلب API
      await Future.delayed(const Duration(seconds: 2));

      // محاكاة نتيجة عشوائية للاختبار
      final isActive = DateTime.now().millisecondsSinceEpoch % 2 == 0;

      setState(() {
        isPixelActive = isActive;
        statusMessage = isActive
            ? 'البكسل مُفعّل ويعمل بشكل صحيح ✨'
            : 'البكسل غير مُفعّل أو يحتاج إلى إعداد 🔧';
      });

      // Add haptic feedback based on result
      if (isActive) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.mediumImpact();
      }

      // Show result snackbar
      Get.snackbar(
        isActive ? '🎉 البكسل نشط' : '⚠️ البكسل غير نشط',
        isActive ? 'البكسل يعمل بشكل مثالي' : 'تحقق من تثبيت الكود في موقعك',
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            isActive ? Colors.green.shade600 : Colors.orange.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        shouldIconPulse: false,
        boxShadows: [
          BoxShadow(
            color: (isActive ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );
    } catch (e) {
      setState(() {
        isPixelActive = false;
        statusMessage = 'حدث خطأ في الاتصال 🔌';
      });

      HapticFeedback.mediumImpact();

      Get.snackbar(
        '🔴 خطأ في الاتصال',
        'تحقق من اتصال الإنترنت وحاول مرة أخرى',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        shouldIconPulse: false,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('إعداد بكسل سناب شات'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 800 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Client Info Card
                  _buildClientInfoCard(theme, isDesktop),
                  const SizedBox(height: 20),

                  // JavaScript Code Section
                  _buildJavaScriptSection(theme, isDesktop),
                  const SizedBox(height: 20),

                  // Status Check Section
                  _buildStatusCheckSection(theme, isDesktop),

                  // Bottom spacing
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfoCard(ThemeData theme, bool isDesktop) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معرّف العميل',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.clientId,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJavaScriptSection(ThemeData theme, bool isDesktop) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.code,
                    size: 24,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'كود بكسل سناب شات',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'انسخ الكود وأضفه إلى موقعك',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Code Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'HTML',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: isDesktop ? 200 : 150,
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        javascriptCode,
                        style: TextStyle(
                          fontSize: isDesktop ? 13 : 11,
                          fontFamily: 'monospace',
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Copy Button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _copyCodeToClipboard();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 16 : 14,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'نسخ الكود',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCheckSection(ThemeData theme, bool isDesktop) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.analytics,
                    size: 24,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فحص حالة البكسل',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'تحقق من تفعيل البكسل',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Check Button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          _checkPixelStatus();
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 16 : 14,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: isLoading
                          ? LinearGradient(
                              colors: [
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.green.shade600,
                                Colors.green.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (isLoading ? Colors.grey : Colors.green)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          isLoading ? 'جاري الفحص...' : 'فحص الحالة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Status Result
            if (isPixelActive != null && statusMessage != null) ...[
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  color: isPixelActive!
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPixelActive!
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isPixelActive!
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPixelActive! ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPixelActive!
                                ? 'البكسل مُفعّل'
                                : 'البكسل غير مُفعّل',
                            style: TextStyle(
                              fontSize: isDesktop ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: isPixelActive!
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusMessage!,
                            style: TextStyle(
                              fontSize: isDesktop ? 14 : 13,
                              color: isPixelActive!
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
