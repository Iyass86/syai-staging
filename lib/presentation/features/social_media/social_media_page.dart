import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_oauth_chat/core/routes/app_routes.dart';
import 'package:flutter_oauth_chat/core/services/storage_service.dart';
import 'package:get/get.dart';
import '../chat/widgets/message_display_container.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageDisplayContainer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Get.theme.colorScheme.surface,
                Get.theme.colorScheme.surface.withOpacity(0.8),
                Get.theme.colorScheme.primaryContainer.withOpacity(0.1),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section with Animation
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Get.theme.colorScheme.primary.withOpacity(0.1),
                        Get.theme.colorScheme.secondary.withOpacity(0.05),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.primary
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.rocket_launch_rounded,
                              color: Get.theme.colorScheme.onPrimary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Social Platforms',
                                  style: Get.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.onSurface,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Connect your social platforms to SyAI and unlock the power of intelligent ad management.',
                                  style: Get.textTheme.bodyLarge?.copyWith(
                                    color: Get.theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildPlatformGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformGrid() {
    final platforms = [
      _PlatformData(
        name: 'Snapchat',
        description: 'snapchat_description'.tr,
        icon: Icons.camera_alt_rounded,
        color: const Color(0xFFFFFC00),
        isConnected: true,
      ),
      _PlatformData(
        name: 'Facebook',
        description: 'facebook_description'.tr,
        icon: Icons.facebook_rounded,
        color: const Color(0xFF1877F2),
        isConnected: true,
      ),
      _PlatformData(
        name: 'Instagram',
        description: 'instagram_description'.tr,
        icon: Icons.camera_rounded,
        color: const Color(0xFFE4405F),
        isConnected: true,
      ),
      _PlatformData(
        name: 'TikTok',
        description: 'tiktok_description'.tr,
        icon: Icons.music_video_rounded,
        color: const Color(0xFF000000),
        isConnected: true,
      ),
      _PlatformData(
        name: 'LinkedIn',
        description: 'linkedin_description'.tr,
        icon: Icons.business_rounded,
        color: const Color(0xFF0077B5),
        isConnected: true,
      ),
      _PlatformData(
        name: 'X',
        description: 'x_description'.tr,
        icon: Icons.close_rounded,
        color: const Color(0xFF000000),
        isConnected: true,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on available space
        final cardWidth =
            (constraints.maxWidth - 32) / 3; // 3 cards per row with spacing
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: platforms
              .map((platform) => SizedBox(
                    width: cardWidth.clamp(180.0, 220.0), // Min 180, Max 220
                    child: _PlatformGridCard(
                      platform: platform,
                      onTap: () => _handlePlatformTap(platform),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  StorageService get _storageService => Get.find<StorageService>();

  void _handlePlatformTap(_PlatformData platform) {
    HapticFeedback.lightImpact();
    if (_storageService.snapTokenResponse?.accessToken.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(AppRoutes.snapOrganizations);
      });
    } else {
      Get.toNamed(AppRoutes.snapAuth);
    }
  }
}

class _PlatformData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isConnected;

  _PlatformData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isConnected,
  });
}

class _PlatformGridCard extends StatefulWidget {
  final _PlatformData platform;
  final VoidCallback onTap;

  const _PlatformGridCard({
    required this.platform,
    required this.onTap,
  });

  @override
  State<_PlatformGridCard> createState() => _PlatformGridCardState();
}

class _PlatformGridCardState extends State<_PlatformGridCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0)
          ..rotateZ(_isHovered ? 0.01 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    widget.platform.color.withOpacity(_isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 15 : 8),
                spreadRadius: _isHovered ? 2 : 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? widget.platform.color.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.1),
              width: _isHovered ? 2 : 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Platform icon with glassmorphism effect
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isHovered ? 65 : 60,
                      height: _isHovered ? 65 : 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.platform.color.withOpacity(0.8),
                            widget.platform.color.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: widget.platform.color.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.platform.icon,
                        size: _isHovered ? 30 : 26,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Platform name with better typography
                    Text(
                      widget.platform.name,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onSurface,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Connected status with enhanced design
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.platform.isConnected
                              ? [
                                  const Color(0xFF4CAF50),
                                  const Color(0xFF45A049),
                                ]
                              : [
                                  Colors.grey.shade400,
                                  Colors.grey.shade500,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: widget.platform.isConnected
                                ? const Color(0xFF4CAF50).withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.platform.isConnected
                                ? Icons.check_circle_rounded
                                : Icons.pending_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.platform.isConnected
                                ? 'Connected'
                                : 'Not Connected',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Add a subtle action hint
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 1.0 : 0.6,
                      child: Text(
                        'Tap to manage',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: widget.platform.color,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
