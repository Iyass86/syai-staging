import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/core/controllers/snap_controllers/snap_accounts_controller.dart';
import 'package:flutter_oauth_chat/core/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/core/models/ad_account.dart';
import 'package:get/get.dart';
import '../chat/widgets/message_display_container.dart';

class SnapAccountsPage extends StatefulWidget {
  const SnapAccountsPage({super.key});

  @override
  State<SnapAccountsPage> createState() => _SnapAccountsPageState();
}

class _SnapAccountsPageState extends State<SnapAccountsPage>
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

    return GetBuilder<SnapAccountsController>(
        builder: (controller) => Scaffold(
              appBar: _buildAppBar(context, controller, colorScheme),
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
                  child: FadeTransition(
                    opacity: _fadeAnimation,
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
                                  Get.theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  Get.theme.colorScheme.secondary
                                      .withOpacity(0.05),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.shadow
                                      .withOpacity(0.1),
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
                                        Icons.account_balance_wallet_rounded,
                                        color: Get.theme.colorScheme.onPrimary,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ad Accounts',
                                            style: Get.textTheme.headlineLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Get
                                                  .theme.colorScheme.onSurface,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Select your Snapchat ad account to manage your campaigns and view analytics.',
                                            style: Get.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: Get
                                                  .theme.colorScheme.onSurface
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
      SnapAccountsController controller, ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildErrorDisplay(
      SnapAccountsController controller, ColorScheme colorScheme) {
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
      SnapAccountsController controller, ColorScheme colorScheme) {
    return Obx(() {
      final response = controller.adAccountsResponse.value;

      if (controller.isLoading.value && response == null) {
        return _buildLoadingState(colorScheme);
      }

      if (response == null) {
        return _buildEmptyState(controller, colorScheme);
      }

      return _buildAccountsGrid(response, controller, colorScheme);
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
              'Loading accounts...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch your ad accounts',
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
      SnapAccountsController controller, ColorScheme colorScheme) {
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
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No accounts found',
              style: TextStyle(
                fontSize: 22,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
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
                onPressed: controller.refreshAdAccounts,
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

  Widget _buildAccountsGrid(AdAccountsResponse response,
      SnapAccountsController controller, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // Enhanced header info
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
        //           Icons.account_balance_wallet_rounded,
        //           color: colorScheme.onPrimary,
        //           size: 24,
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       Text(
        //         '${response.adAccounts.length} Ad Accounts Found',
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
        // // Accounts grid
        _buildAccountsGridLayout(response.adAccounts, controller, colorScheme),
      ],
    );
  }

  Widget _buildAccountsGridLayout(List<AdAccountItem> adAccounts,
      SnapAccountsController controller, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on available space
        final cardWidth =
            (constraints.maxWidth - 32) / 3; // 3 cards per row with spacing
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: adAccounts
              .map((accountItem) => SizedBox(
                    width: cardWidth.clamp(180.0, 220.0), // Min 180, Max 220
                    child: _AdAccountGridCard(
                      adAccount: accountItem.adAccount,
                      onTap: () =>
                          controller.selectAdAccount(accountItem.adAccount),
                      onPixelsTap: () =>
                          controller.viewPixels(accountItem.adAccount),
                      colorScheme: colorScheme,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _AdAccountGridCard extends StatefulWidget {
  final AdAccount adAccount;
  final VoidCallback onTap;
  final VoidCallback onPixelsTap;
  final ColorScheme colorScheme;

  const _AdAccountGridCard({
    required this.adAccount,
    required this.onTap,
    required this.onPixelsTap,
    required this.colorScheme,
  });

  @override
  State<_AdAccountGridCard> createState() => _AdAccountGridCardState();
}

class _AdAccountGridCardState extends State<_AdAccountGridCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.adAccount.status == 'ACTIVE';

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
                color: (isActive ? Colors.green : Colors.orange)
                    .withOpacity(_isHovered ? 0.4 : 0.2),
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
                  ? (isActive ? Colors.green : Colors.orange).withOpacity(0.6)
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
                    // Account avatar and pixels button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Account avatar with enhanced design
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _isHovered ? 45 : 40,
                          height: _isHovered ? 45 : 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (isActive ? Colors.green : Colors.orange)
                                    .withOpacity(0.8),
                                (isActive ? Colors.green : Colors.orange)
                                    .withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: (isActive ? Colors.green : Colors.orange)
                                    .withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.adAccount.name.isNotEmpty
                                  ? widget.adAccount.name[0].toUpperCase()
                                  : 'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: _isHovered ? 16 : 14,
                              ),
                            ),
                          ),
                        ),

                        // Enhanced pixels button
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Account name with improved typography
                    Text(
                      widget.adAccount.name,
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

                    // Enhanced status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (isActive ? Colors.green : Colors.orange)
                                .withOpacity(0.15),
                            (isActive ? Colors.green : Colors.orange)
                                .withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (isActive ? Colors.green : Colors.orange)
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.adAccount.status,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: isActive
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Currency and Type row with enhanced design
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surfaceVariant
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.adAccount.currency,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.adAccount.type,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
