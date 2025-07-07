import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsets padding;
  final Widget? customContent;

  const EmptyListWidget({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? theme.colorScheme.primary.withOpacity(0.6),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (customContent != null) ...[
            const SizedBox(height: 24),
            customContent!,
          ],
          if (actionText != null && onActionPressed != null) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Icons.add),
              label: Text(actionText!),
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
    );
  }
}
