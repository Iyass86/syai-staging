import 'package:flutter/material.dart';
import 'animated_empty_list_widget.dart';

class EmptyStateVariations {
  static Widget noSearchResults({
    required String searchQuery,
    VoidCallback? onClearSearch,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Results Found",
      message: "We couldn't find anything matching \"$searchQuery\"",
      icon: Icons.search_off,
      actionText: "Clear Search",
      onActionPressed: onClearSearch,
      iconColor: Colors.orange,
    );
  }

  static Widget noFavorites({
    VoidCallback? onBrowseItems,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Favorites Yet",
      message: "Items you favorite will appear here for quick access",
      icon: Icons.favorite_border,
      actionText: "Browse Items",
      onActionPressed: onBrowseItems,
      iconColor: Colors.red,
    );
  }

  static Widget noNotifications() {
    return AnimatedEmptyListWidget(
      title: "All Caught Up!",
      message: "You have no new notifications",
      icon: Icons.notifications_none,
      iconColor: Colors.green,
    );
  }

  static Widget networkError({
    required VoidCallback onRetry,
  }) {
    return AnimatedEmptyListWidget(
      title: "Connection Error",
      message: "Please check your internet connection and try again",
      icon: Icons.wifi_off,
      actionText: "Retry",
      onActionPressed: onRetry,
      iconColor: Colors.red,
    );
  }

  static Widget noSnapAccounts({
    VoidCallback? onConnect,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Accounts Found",
      message: "You don't have any Snapchat ad accounts connected yet",
      icon: Icons.account_balance_wallet_outlined,
      actionText: "Connect Account",
      onActionPressed: onConnect,
      iconColor: const Color(0xFFFFFC00),
    );
  }

  static Widget noSnapOrganizations({
    VoidCallback? onRefresh,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Organizations Found",
      message: "You don't have access to any Snapchat organizations",
      icon: Icons.business_outlined,
      actionText: "Refresh",
      onActionPressed: onRefresh,
      iconColor: const Color(0xFFFFFC00),
    );
  }

  static Widget noSnapPixels({
    VoidCallback? onCreate,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Pixels Found",
      message: "You haven't created any Snapchat pixels yet",
      icon: Icons.code_outlined,
      actionText: "Create Pixel",
      onActionPressed: onCreate,
      iconColor: const Color(0xFFFFFC00),
    );
  }

  static Widget noChatMessages({
    VoidCallback? onStartChat,
  }) {
    return AnimatedEmptyListWidget(
      title: "Start a Conversation",
      message: "Ask me anything about your marketing campaigns and performance",
      icon: Icons.chat_bubble_outline,
      actionText: "Start Chatting",
      onActionPressed: onStartChat,
      iconColor: Colors.blue,
    );
  }

  static Widget noDataAvailable({
    VoidCallback? onRefresh,
  }) {
    return AnimatedEmptyListWidget(
      title: "No Data Available",
      message: "There's no data to display at the moment",
      icon: Icons.data_usage_outlined,
      actionText: "Refresh",
      onActionPressed: onRefresh,
      iconColor: Colors.grey,
    );
  }

  static Widget customEmpty({
    required String title,
    required String message,
    required IconData icon,
    Widget? customContent,
    String? actionText,
    VoidCallback? onAction,
    Color? iconColor,
  }) {
    return AnimatedEmptyListWidget(
      title: title,
      message: message,
      icon: icon,
      customContent: customContent,
      actionText: actionText,
      onActionPressed: onAction,
      iconColor: iconColor,
    );
  }
}
