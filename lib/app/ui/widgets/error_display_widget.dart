import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onDismiss;
  final bool isVisible;

  const ErrorDisplayWidget({
    super.key,
    required this.errorMessage,
    this.onDismiss,
    this.isVisible = true,
  });

  @override
  State<ErrorDisplayWidget> createState() => _ErrorDisplayWidgetState();
}

class _ErrorDisplayWidgetState extends State<ErrorDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ErrorDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!widget.isVisible || widget.errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.error.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خطأ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.errorMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onErrorContainer,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onDismiss != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onDismiss,
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.error.withOpacity(0.1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NetworkErrorDisplayWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;
  final bool isVisible;

  const NetworkErrorDisplayWidget({
    super.key,
    required this.errorMessage,
    this.onDismiss,
    this.onRetry,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                color: Colors.orange[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خطأ في الاتصال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يرجى التحقق من:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCheckItem('• اتصال الإنترنت'),
                _buildCheckItem('• إعدادات Firewall'),
                _buildCheckItem('• إعدادات VPN'),
                _buildCheckItem('• إعادة تحميل الصفحة'),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.orange[700],
        ),
      ),
    );
  }
}

class SuccessDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool isVisible;

  const SuccessDisplayWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نجحت العملية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: Colors.green[700],
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.1),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(4),
                minimumSize: const Size(32, 32),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
