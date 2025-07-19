import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import '../../../core/controllers/snap_controllers/snap_auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class SnapOAuthCallbackPage extends StatefulWidget {
  const SnapOAuthCallbackPage({Key? key}) : super(key: key);

  @override
  State<SnapOAuthCallbackPage> createState() => _SnapOAuthCallbackPageState();
}

class _SnapOAuthCallbackPageState extends State<SnapOAuthCallbackPage> {
  late final SnapAuthController _snapAuthController;

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
    _handleSnapCallback();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSnapCallback() async {
    try {
      // Get the current URL
      currentUrl = html.window.location.href;

      // Use the controller's callback handler
      await _snapAuthController.handleOAuthCallback(currentUrl);

      // If we reach here, the callback was successful
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
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Snapchat Icon
              Icon(
                Icons.snapchat,
                size: 64,
                color: Color(0xFFFFFC00),
              ),
              const SizedBox(height: 32),

              // Status Message
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _hasError ? Colors.red : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Detail Message
              Text(
                _detailMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Loading Indicator or Action Buttons
              if (_isProcessing)
                CircularProgressIndicator(
                  color: Color(0xFFFFFC00),
                )
              else
                _buildSimpleActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleActionButtons() {
    if (_hasError) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: _retryAuthentication,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFFC00),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Try Again'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _goToDashboard,
            child: Text('Go to Dashboard'),
          ),
        ],
      );
    } else if (!_isProcessing && !_hasError) {
      return Column(
        children: [
          Text(
            'Authentication successful!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoadingToken ? null : _handleTokenGeneration,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFFC00),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoadingToken
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Text('Generate Access Token'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
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
