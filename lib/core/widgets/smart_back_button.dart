import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/browser_navigation_service.dart';

/// A smart back button widget that handles browser navigation properly
/// Use this instead of the default back button for better web navigation
class SmartBackButton extends StatelessWidget {
  final String? fallbackRoute;
  final VoidCallback? onPressed;
  final Color? color;
  final double? iconSize;
  final String? tooltip;

  const SmartBackButton({
    Key? key,
    this.fallbackRoute,
    this.onPressed,
    this.color,
    this.iconSize,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => _handleBackPress(),
      icon: Icon(
        Icons.arrow_back,
        color: color,
        size: iconSize,
      ),
      tooltip: tooltip ?? 'Back',
    );
  }

  void _handleBackPress() {
    if (BrowserNavigationService.canGoBack()) {
      Get.back();
    } else if (fallbackRoute != null) {
      BrowserNavigationService.navigateToFeature(fallbackRoute!);
    } else {
      // Default fallback behavior
      BrowserNavigationService.goBack();
    }
  }
}

/// A smart app bar that includes the smart back button
class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? fallbackRoute;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;

  const SmartAppBar({
    Key? key,
    required this.title,
    this.fallbackRoute,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      automaticallyImplyLeading: false,
      leading: automaticallyImplyLeading && BrowserNavigationService.canGoBack()
          ? SmartBackButton(
              fallbackRoute: fallbackRoute,
              color: foregroundColor,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Extension on GetBuilder to add smart navigation methods
extension SmartNavigation on Widget {
  /// Wrap a widget with smart back button handling
  Widget withSmartBack({String? fallbackRoute}) {
    return WillPopScope(
      onWillPop: () async {
        if (BrowserNavigationService.canGoBack()) {
          Get.back();
          return false;
        } else if (fallbackRoute != null) {
          BrowserNavigationService.navigateToFeature(fallbackRoute);
          return false;
        }
        return true;
      },
      child: this,
    );
  }
}
