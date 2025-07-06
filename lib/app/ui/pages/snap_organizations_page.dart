import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_accounts_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_auth_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_organizations_controller.dart';
import 'package:flutter_oauth_chat/app/data/models/organization.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../widgets/message_display_container.dart';

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
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Text(
        'Organizations',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
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
        const SizedBox(width: 8),
        Obx(() => IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.refreshOrganizations,
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
      SnapOrganizationsController controller, ColorScheme colorScheme) {
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
      SnapOrganizationsController controller, ColorScheme colorScheme) {
    return Obx(() {
      final response = controller.organizationsResponse.value;

      if (controller.isLoading.value && response == null) {
        return _buildLoadingState(colorScheme);
      }

      if (response == null) {
        return _buildEmptyState(controller, colorScheme);
      }

      return _buildOrganizationsList(response, controller, colorScheme);
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
                  'Loading accounts...',
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
      SnapOrganizationsController controller, ColorScheme colorScheme) {
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
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(height: 24),
                Text(
                  'No accounts found',
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap refresh to load your ad accounts',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.refreshOrganizations,
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

  Widget _buildOrganizationsList(OrganizationsResponse response,
      SnapOrganizationsController controller, ColorScheme colorScheme) {
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
                    Icons.account_balance_wallet,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '(${response.organizations.length}) ',
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
          // Organizations list
          Expanded(
            child: ListView.separated(
              itemCount: response.organizations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = response.organizations[index];
                final organization = item.organization;
                final isActive = true;

                return Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.onTapOrganization(organization),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                isActive ? Colors.green : Colors.orange,
                            child: Text(
                              organization.name.isNotEmpty
                                  ? organization.name[0].toUpperCase()
                                  : 'A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Account Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        organization.name,
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
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${isActive ? 'Active' : 'Inactive'}",
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
                                      Icons.monetization_on_outlined,
                                      size: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      organization.addressLine1.isNotEmpty
                                          ? organization.addressLine1
                                          : 'no_address'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.business_outlined,
                                      size: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        organization.type,
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
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.badge_outlined,
                                      size: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'ID: ${organization.id}',
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
                          // Arrow
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colorScheme.onSurface.withOpacity(0.4),
                            size: 16,
                          ),
                        ],
                      ),
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
