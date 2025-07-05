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

class _SnapOAuthCallbackPageState extends State<SnapOAuthCallbackPage> {
  late final SnapAuthController _snapAuthController;
  bool _isProcessing = true;
  bool _isLoading = true;
  String _statusMessage = 'Processing Snapchat authentication...';
  String _detailMessage = 'Please wait while we complete your Snapchat login.';
  bool _hasError = false;
  SnapAuthController get snapAuthController => Get.find<SnapAuthController>();
  String currentUrl = '';
  @override
  void initState() {
    super.initState();
    _handleSnapCallback();
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
        _detailMessage = 'Redirecting to your Snapchat organizations...';
      });

      // Add a small delay before navigation
      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigation will be handled by the controller
    } catch (e) {
      _handleProcessingError(e);
    }
  }

  void _handleProcessingError(dynamic error) {
    setState(() {
      _isProcessing = false;
      _hasError = true;
      _statusMessage = 'Processing error';
      _detailMessage =
          'An error occurred while processing your authentication. Please try again.';
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hasError
                          ? Colors.red.withOpacity(0.1)
                          : _isProcessing
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                    ),
                    child: _hasError
                        ? Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[700],
                          )
                        : _isProcessing
                            ? const SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                Icons.check_circle_outline,
                                size: 48,
                                color: Colors.green[700],
                              ),
                  ),
                  const SizedBox(height: 24),

                  // Status Message
                  Text(
                    _statusMessage,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _hasError ? Colors.red[700] : null,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Detail Message
                  Text(
                    _detailMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  // Action Buttons (only show if there's an error)
                  if (_hasError) ...[
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _retryAuthentication,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _goToDashboard,
                          icon: const Icon(Icons.home),
                          label: const Text('Go to Dashboard'),
                        ),
                      ],
                    ),
                  ],

                  // Pass Code Button (show when authentication is successful)
                  if (!_isProcessing && !_hasError) ...[
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _snapAuthController.generateAccessToken();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      icon: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isLoading
                          ? 'Processing...'
                          : 'Pass Code to Localhost'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
