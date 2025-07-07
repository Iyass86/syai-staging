import 'package:flutter/material.dart';

class AnimatedEmptyListWidget extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsets padding;
  final Widget? customContent;
  final Duration animationDuration;

  const AnimatedEmptyListWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.iconSize = 80.0,
    this.padding = const EdgeInsets.all(32.0),
    this.customContent,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<AnimatedEmptyListWidget> createState() =>
      _AnimatedEmptyListWidgetState();
}

class _AnimatedEmptyListWidgetState extends State<AnimatedEmptyListWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                padding: widget.padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 0.1,
                          child: Icon(
                            widget.icon,
                            size: widget.iconSize,
                            color: widget.iconColor ??
                                theme.colorScheme.primary.withOpacity(0.6),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.customContent != null) ...[
                      const SizedBox(height: 24),
                      widget.customContent!,
                    ],
                    if (widget.actionText != null &&
                        widget.onActionPressed != null) ...[
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: widget.onActionPressed,
                        icon: const Icon(Icons.add),
                        label: Text(widget.actionText!),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
