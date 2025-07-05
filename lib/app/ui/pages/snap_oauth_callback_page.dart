import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import '../../controllers/snap_controllers/snap_auth_controller.dart';
import '../../routes/app_routes.dart';

class SnapOAuthCallbackPage extends StatefulWidget {
  const SnapOAuthCallbackPage({Key? key}) : super(key: key);

  @override
  State<SnapOAuthCallbackPage> createState() => _SnapOAuthCallbackPageState();
}

class _SnapOAuthCallbackPageState extends State<SnapOAuthCallbackPage>
    with TickerProviderStateMixin {
  late final SnapAuthController _snapAuthController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isProcessing = true;
  bool _isLoadingToken = false;
  String _statusMessage = 'Processing Snapchat authentication...';
  String _detailMessage = 'Please wait while we complete your Snapchat login.';
  bool _hasError = false;
  SnapAuthController get snapAuthController => Get.find<SnapAuthController>();
  String currentUrl = '';
  @override
  void initState() {
    super.initState();
    _snapAuthController = Get.find<SnapAuthController>();
    _initializeAnimations();
    _handleSnapCallback();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    if (_isProcessing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleSnapCallback() async {
    try {
      // Get the current URL
      currentUrl = html.window.location.href;

      // Use the controller's callback handler
      await _snapAuthController.handleOAuthCallback(currentUrl);

      // If we reach here, the callback was successful
      _pulseController.stop();

      setState(() {
        _isProcessing = false;
        _statusMessage = 'Authentication successful!';
        _detailMessage =
            'You have successfully connected your Snapchat account.';
      });

      // Add a small delay before showing success animation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleProcessingError(e);
    }
  }

  void _handleProcessingError(dynamic error) {
    _pulseController.stop();

    setState(() {
      _isProcessing = false;
      _hasError = true;
      _statusMessage = 'Authentication failed';
      _detailMessage =
          'Something went wrong while processing your authentication. Please try again.';
    });

    debugPrint('Callback processing error: $error');
  }

  void _retryAuthentication() {
    Get.offAllNamed(AppRoutes.snapAuth);
  }

  void _goToDashboard() {
    Get.offAllNamed(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFC00), // Snapchat yellow
              Color(0xFFFF6B6B), // Coral pink
              Color(0xFF4ECDC4), // Turquoise
              Color(0xFF6C5CE7), // Purple
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated Snapchat Ghost
                            _buildSnapchatGhost(),
                            const SizedBox(height: 32),

                            // Status Icon with Animation
                            _buildStatusIcon(),
                            const SizedBox(height: 24),

                            // Status Message
                            Text(
                              _statusMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _hasError
                                        ? const Color(0xFFFF6B6B)
                                        : const Color(0xFF2C3E50),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),

                            // Detail Message
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _detailMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      height: 1.5,
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action Buttons
                            _buildActionButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSnapchatGhost() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isProcessing ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFFC00).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFC00),
                      width: 3,
                    ),
                  ),
                ),
                // Inner ghost icon
                const Icon(
                  Icons.adb_outlined,
                  size: 40,
                  color: Color(0xFFFFFC00),
                ),
                // Small floating dots
                if (_isProcessing) ...[
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ECDC4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B6B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon() {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFF6B6B).withOpacity(0.1),
              const Color(0xFFFF6B6B).withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.error_outline_rounded,
          size: 40,
          color: Color(0xFFFF6B6B),
        ),
      );
    } else if (_isProcessing) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFFC00).withOpacity(0.1),
              const Color(0xFF4ECDC4).withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            ),
            const Icon(
              Icons.autorenew_rounded,
              size: 20,
              color: Color(0xFF4ECDC4),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00D4AA).withOpacity(0.1),
              const Color(0xFF00D4AA).withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00D4AA).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          size: 40,
          color: Color(0xFF00D4AA),
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    if (_hasError) {
      return Column(
        children: [
          _buildGradientButton(
            onPressed: _retryAuthentication,
            icon: Icons.refresh_rounded,
            label: 'Try Again',
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFC00), Color(0xFFFF6B6B)],
            ),
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          _buildGlassButton(
            onPressed: _goToDashboard,
            icon: Icons.home_rounded,
            label: 'Go to Dashboard',
          ),
        ],
      );
    } else if (!_isProcessing && !_hasError) {
      return Column(
        children: [
          // Success indicator
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00D4AA).withOpacity(0.1),
                  const Color(0xFF4ECDC4).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00D4AA).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00D4AA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Connected!',
                        style: TextStyle(
                          color: Color(0xFF00D4AA),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Your Snapchat account is ready to use',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildGradientButton(
            onPressed: _isLoadingToken ? null : _handleTokenGeneration,
            icon: _isLoadingToken ? null : Icons.token_rounded,
            label: _isLoadingToken ? 'Processing...' : 'Generate Access Token',
            gradient: const LinearGradient(
              colors: [Color(0xFF4ECDC4), Color(0xFF6C5CE7)],
            ),
            textColor: Colors.white,
            isLoading: _isLoadingToken,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    IconData? icon,
    required String label,
    required Gradient gradient,
    required Color textColor,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? gradient
              : LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else if (icon != null)
                    Icon(icon, color: textColor, size: 20),
                  if (!isLoading && icon != null) const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTokenGeneration() async {
    setState(() {
      _isLoadingToken = true;
    });

    try {
      await _snapAuthController.generateAccessToken();
      // Show success message briefly
      setState(() {
        _detailMessage = 'Access token generated successfully!';
      });

      // Navigate after a short delay
      await Future.delayed(const Duration(seconds: 1));
      // _goToDashboard();
    } catch (e) {
      setState(() {
        _detailMessage = 'Failed to generate access token. Please try again.';
      });
      debugPrint('Token generation error: $e');
    } finally {
      setState(() {
        _isLoadingToken = false;
      });
    }
  }
}
