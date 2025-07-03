import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildPlatformCards(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlatformCards() {
    final platforms = [
      _PlatformData(
        name: 'Snapchat',
        description: 'snapchat_description'.tr,
        icon: Icons.camera_alt_rounded,
        color: const Color(0xFFFFFC00),
        isAvailable: true,
      ),
      _PlatformData(
        name: 'Facebook',
        description: 'facebook_description'.tr,
        icon: Icons.facebook_rounded,
        color: const Color(0xFF1877F2),
        isAvailable: false,
      ),
      _PlatformData(
        name: 'Instagram',
        description: 'instagram_description'.tr,
        icon: Icons.camera_rounded,
        color: const Color(0xFFE4405F),
        isAvailable: false,
      ),
      _PlatformData(
        name: 'TikTok',
        description: 'tiktok_description'.tr,
        icon: Icons.music_video_rounded,
        color: const Color(0xFF000000),
        isAvailable: false,
      ),
    ];

    return platforms
        .map((platform) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PlatformCard(
                platform: platform,
                onTap: platform.isAvailable
                    ? () => _handlePlatformTap(platform)
                    : null,
              ),
            ))
        .toList();
  }

  void _handlePlatformTap(_PlatformData platform) {
    HapticFeedback.lightImpact();

    Get.toNamed(AppRoutes.snapAuth);
  }
}

class _PlatformData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isAvailable;

  _PlatformData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isAvailable,
  });
}

class _PlatformCard extends StatefulWidget {
  final _PlatformData platform;
  final VoidCallback? onTap;

  const _PlatformCard({
    required this.platform,
    this.onTap,
  });

  @override
  State<_PlatformCard> createState() => _PlatformCardState();
}

class _PlatformCardState extends State<_PlatformCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.platform.isAvailable;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered && isAvailable ? 1.02 : 1.0),
        child: Card(
          elevation: _isHovered && isAvailable ? 8 : 2,
          shadowColor:
              isAvailable ? widget.platform.color.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isHovered && isAvailable
                  ? widget.platform.color.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Platform icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? widget.platform.color.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isAvailable
                              ? widget.platform.color.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            widget.platform.icon,
                            size: 28,
                            color: isAvailable
                                ? widget.platform.color
                                : Colors.grey,
                          ),
                          if (!isAvailable)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Platform info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.platform.name,
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isAvailable
                                  ? Get.theme.colorScheme.onSurface
                                  : Get.theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.platform.description,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isAvailable ? 'available'.tr : 'coming_soon'.tr,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color:
                                    isAvailable ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow or lock icon
                    Icon(
                      isAvailable
                          ? Icons.arrow_forward_ios
                          : Icons.lock_outline,
                      size: 20,
                      color: isAvailable ? widget.platform.color : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
