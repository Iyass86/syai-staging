import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_oauth_chat/core/controllers/snap_controllers/snap_pixels_controller.dart';
import 'package:flutter_oauth_chat/core/models/pixel.dart';
import 'package:get/get.dart';
import '../chat/widgets/message_display_container.dart';
import '../../shared_widgets/enhanced_list_view.dart';

class SnapPixelsPage extends StatefulWidget {
  const SnapPixelsPage({super.key});

  @override
  State<SnapPixelsPage> createState() => _SnapPixelsPageState();
}

class _SnapPixelsPageState extends State<SnapPixelsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GetBuilder<SnapPixelsController>(
        builder: (controller) => Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: _buildAppBar(context, controller, colorScheme),
              body: MessageDisplayContainer(
                child: Container(
                  color: colorScheme.surface,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildErrorDisplay(controller, colorScheme),
                          _buildMainContent(controller, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context,
      SnapPixelsController controller, ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'pixels'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            controller.adAccountName,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
      actions: [
        Obx(() => IconButton(
              onPressed:
                  controller.isLoading.value ? null : controller.refreshPixels,
              icon: controller.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.refresh,
                      color: colorScheme.onSurface,
                    ),
              tooltip: 'refresh'.tr,
            )),
      ],
    );
  }

  Widget _buildErrorDisplay(
      SnapPixelsController controller, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.errorMessage.value = '',
              icon: Icon(Icons.close, color: colorScheme.error, size: 18),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMainContent(
      SnapPixelsController controller, ColorScheme colorScheme) {
    return Obx(() {
      final response = controller.pixelsResponse.value;

      if (controller.isLoading.value && response == null) {
        return _buildLoadingState(colorScheme);
      }

      if (response == null) {
        return _buildEmptyState(controller, colorScheme);
      }

      return _buildPixelsList(response, controller, colorScheme);
    });
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Expanded(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'loading_pixels'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      SnapPixelsController controller, ColorScheme colorScheme) {
    return Expanded(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(height: 24),
                Text(
                  'no_pixels_found'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'tap_refresh_pixels'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.refreshPixels,
                  icon: const Icon(Icons.refresh),
                  label: Text('refresh'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelsList(PixelsResponse response,
      SnapPixelsController controller, ColorScheme colorScheme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${response.pixels.length} pixels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pixels list
          Expanded(
            child: EnhancedListView.separated(
              items: response.pixels,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              emptyTitle: "No Pixels Found",
              emptyMessage:
                  "You haven't created any Snapchat pixels yet. Create your first pixel to start tracking conversions.",
              emptyIcon: Icons.code_outlined,
              emptyActionText: "Create Pixel",
              onEmptyAction: () {
                // Handle refresh action
                controller.refreshPixels();
              },
              itemBuilder: (context, item, index) {
                final pixel = item.pixel;
                final isActive = pixel.isActive;

                return Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            // Status Indicator
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isActive ? Colors.green : Colors.orange,
                              child: Icon(
                                isActive ? Icons.check : Icons.warning,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Pixel Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pixel.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          pixel.status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isActive
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 14,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Created: ${_formatDate(pixel.createdAt)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        size: 14,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'ID: ${pixel.id}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _copyPixelCode(pixel),
                                icon: const Icon(Icons.copy, size: 16),
                                label: Text('copy_pixel_code'.tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.primary.withOpacity(0.1),
                                  foregroundColor: colorScheme.primary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    controller.navigateToPixelSetup(pixel.id),
                                icon: const Icon(Icons.settings, size: 16),
                                label: Text('pixel_setup'.tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyPixelCode(Pixel pixel) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: pixel.pixelJavascript));

    Get.snackbar(
      '✅ تم النسخ بنجاح',
      'تم نسخ كود البكسل "${pixel.name}" إلى الحافظة',
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
    );
  }
}
