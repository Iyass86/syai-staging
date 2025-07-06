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
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFFC00).withOpacity(0.1), // Snapchat yellow
              Colors.white,
              Colors.white,
            ],
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
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Snapchat Logo/Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFC00),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.snapchat,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),

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
                                      ? Colors.red[700]
                                      : Colors.grey[800],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),

                          // Detail Message
                          Text(
                            _detailMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.center,
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
    );
  }

  Widget _buildStatusIcon() {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.withOpacity(0.1),
          border: Border.all(
            color: Colors.red.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red[700],
        ),
      );
    } else if (_isProcessing) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFFC00).withOpacity(0.1),
                border: Border.all(
                  color: const Color(0xFFFFFC00).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFC00)),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.withOpacity(0.1),
          border: Border.all(
            color: Colors.green.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.check_circle_outline,
          size: 48,
          color: Colors.green[700],
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    if (_hasError) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _retryAuthentication,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFC00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _goToDashboard,
              icon: const Icon(Icons.home),
              label: const Text('Go to Dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      );
    } else if (!_isProcessing && !_hasError) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your Snapchat account is now connected!',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingToken ? null : _handleTokenGeneration,
              icon: _isLoadingToken
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(
                  _isLoadingToken ? 'Processing...' : 'Generate Access Token'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFC00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
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
