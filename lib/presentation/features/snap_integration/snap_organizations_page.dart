import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/core/controllers/snap_controllers/snap_auth_controller.dart';
import 'package:flutter_oauth_chat/core/controllers/snap_controllers/snap_organizations_controller.dart';
import 'package:flutter_oauth_chat/core/models/organization.dart';
import 'package:get/get.dart';
import '../chat/widgets/message_display_container.dart';

class SnapOrganizationsPage extends StatefulWidget {
  const SnapOrganizationsPage({super.key});

  @override
  State<SnapOrganizationsPage> createState() => _SnapOrganizationsPageState();
}

class _SnapOrganizationsPageState extends State<SnapOrganizationsPage>
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

    return GetBuilder<SnapOrganizationsController>(
        builder: (controller) => Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: _buildAppBar(context, controller, colorScheme),
              body: MessageDisplayContainer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.surface,
                        colorScheme.primaryContainer.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Hero Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFFFFC00).withOpacity(0.1),
                                  const Color(0xFFFFFC00).withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(0xFFFFFC00).withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFFFFC00).withOpacity(0.1),
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
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFFFC00),
                                            Color(0xFFE6D700)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFFC00)
                                                .withOpacity(0.4),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.business_rounded,
                                        color: Colors.black,
                                        size: 36,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Organizations',
                                            style: Get.textTheme.headlineLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurface,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Select your Snapchat organization to unlock powerful advertising tools and insights.',
                                            style: Get.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: colorScheme.onSurface
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
                          const SizedBox(height: 32),
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
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      automaticallyImplyLeading: false,
      actions: [
        // Disconnect Snap Auth Button
        IconButton(
          onPressed: () => _showDisconnectDialog(context),
          icon: Icon(
            Icons.logout_outlined,
            color: colorScheme.error,
            size: 22,
          ),
          tooltip: 'Disconnect Snapchat',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.errorContainer.withOpacity(0.1),
            foregroundColor: colorScheme.error,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.errorContainer.withOpacity(0.8),
              colorScheme.errorContainer.withOpacity(0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.error.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: colorScheme.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => controller.errorMessage.value = '',
                icon: Icon(
                  Icons.close_rounded,
                  color: colorScheme.error,
                  size: 18,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMainContent(
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return Obx(() {
      final response = controller.organizationsResponse.value;

      if (controller.isLoading.value && response == null) {
        return _buildLoadingState(colorScheme);
      }

      if (response == null) {
        return _buildEmptyState(controller, colorScheme);
      }

      return _buildOrganizationsGrid(response, controller, colorScheme);
    });
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(40),
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
              color: colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading organizations...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch your organizations',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(40),
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
              color: colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_outlined,
                size: 48,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No organizations found',
              style: TextStyle(
                fontSize: 22,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap refresh to load your organizations',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: controller.refreshOrganizations,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('refresh'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationsGrid(OrganizationsResponse response,
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced header info
        // Container(
        //   margin: const EdgeInsets.only(bottom: 24),
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         colorScheme.primaryContainer.withOpacity(0.8),
        //         colorScheme.primaryContainer.withOpacity(0.4),
        //       ],
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: colorScheme.primary.withOpacity(0.1),
        //         blurRadius: 15,
        //         offset: const Offset(0, 5),
        //       ),
        //     ],
        //     border: Border.all(
        //       color: colorScheme.primary.withOpacity(0.2),
        //       width: 1,
        //     ),
        //   ),
        //   child: Row(
        //     children: [
        //       Container(
        //         padding: const EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //           color: colorScheme.primary,
        //           borderRadius: BorderRadius.circular(12),
        //           boxShadow: [
        //             BoxShadow(
        //               color: colorScheme.primary.withOpacity(0.3),
        //               blurRadius: 10,
        //               offset: const Offset(0, 3),
        //             ),
        //           ],
        //         ),
        //         child: Icon(
        //           Icons.business_rounded,
        //           color: colorScheme.onPrimary,
        //           size: 24,
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       Text(
        //         '${response.organizations.length} Organizations Found',
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.w600,
        //           color: colorScheme.onSurface,
        //           letterSpacing: -0.2,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // // Organizations grid
        _buildOrganizationsGridLayout(
            response.organizations, controller, colorScheme),
      ],
    );
  }

  Widget _buildOrganizationsGridLayout(List<OrganizationWrapper> organizations,
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on available space
        final cardWidth =
            (constraints.maxWidth - 32) / 3; // 3 cards per row with spacing
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: organizations
              .map((orgWrapper) => SizedBox(
                    width: cardWidth.clamp(180.0, 220.0), // Min 180, Max 220
                    child: _OrganizationGridCard(
                      organization: orgWrapper.organization,
                      onTap: () =>
                          controller.onTapOrganization(orgWrapper.organization),
                      colorScheme: colorScheme,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  /// Show disconnect confirmation dialog
  void _showDisconnectDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surfaceTint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Disconnect Snapchat',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to disconnect your Snapchat account? You will need to authenticate again to access your ads data.',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurface.withOpacity(0.7),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _disconnectSnapAuth();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.logout_outlined, size: 16),
              label: const Text('Disconnect'),
            ),
          ],
        );
      },
    );
  }

  /// Disconnect Snap authentication
  void _disconnectSnapAuth() {
    final snapAuthController = Get.find<SnapAuthController>();
    snapAuthController.disconnectSnapAuth();
  }
}

class _OrganizationGridCard extends StatefulWidget {
  final Organization organization;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _OrganizationGridCard({
    required this.organization,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_OrganizationGridCard> createState() => _OrganizationGridCardState();
}

class _OrganizationGridCardState extends State<_OrganizationGridCard> {
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
                color: Colors.green.withOpacity(_isHovered ? 0.4 : 0.2),
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
                  ? Colors.green.withOpacity(0.6)
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
                    // Enhanced organization avatar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isHovered ? 50 : 45,
                      height: _isHovered ? 50 : 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.withOpacity(0.8),
                            Colors.green.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.organization.name.isNotEmpty
                              ? widget.organization.name[0].toUpperCase()
                              : 'O',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: _isHovered ? 18 : 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Organization name with improved typography
                    Text(
                      widget.organization.name,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onSurface,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Enhanced active status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.15),
                            Colors.green.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Active',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Organization type with enhanced design
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surfaceVariant
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.organization.type.isNotEmpty
                            ? widget.organization.type
                            : 'Organization',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color:
                              Get.theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
