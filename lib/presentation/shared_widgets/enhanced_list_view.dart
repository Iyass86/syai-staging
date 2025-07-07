import 'package:flutter/material.dart';
import 'animated_empty_list_widget.dart';

class EnhancedListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final String? emptyActionText;
  final VoidCallback? onEmptyAction;
  final bool isLoading;
  final Widget? loadingWidget;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? header;
  final Widget? footer;
  final bool useAnimatedEmpty;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Axis scrollDirection;

  const EnhancedListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    this.emptyActionText,
    this.onEmptyAction,
    this.isLoading = false,
    this.loadingWidget,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.header,
    this.footer,
    this.useAnimatedEmpty = true,
    this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  // Named constructor for separated lists
  const EnhancedListView.separated({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required Widget Function(BuildContext, int) separatorBuilder,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    this.emptyActionText,
    this.onEmptyAction,
    this.isLoading = false,
    this.loadingWidget,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.header,
    this.footer,
    this.useAnimatedEmpty = true,
    this.scrollDirection = Axis.vertical,
  })  : separatorBuilder = separatorBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return useAnimatedEmpty
          ? AnimatedEmptyListWidget(
              title: emptyTitle,
              message: emptyMessage,
              icon: emptyIcon,
              actionText: emptyActionText,
              onActionPressed: onEmptyAction,
            )
          : Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    emptyIcon,
                    size: 80.0,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    emptyTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    emptyMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (emptyActionText != null && onEmptyAction != null) ...[
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: onEmptyAction,
                      icon: const Icon(Icons.add),
                      label: Text(emptyActionText!),
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

    if (separatorBuilder != null) {
      return ListView.separated(
        controller: scrollController,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: scrollDirection,
        itemCount: _getItemCount(),
        separatorBuilder: (context, index) {
          // Handle separator for header/footer
          if (header != null && index == 0) {
            return const SizedBox.shrink();
          }

          final itemIndex = header != null ? index - 1 : index;
          if (footer != null && itemIndex >= items.length - 1) {
            return const SizedBox.shrink();
          }

          return separatorBuilder!(context, itemIndex);
        },
        itemBuilder: (context, index) => _buildItem(context, index),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      itemCount: _getItemCount(),
      itemBuilder: (context, index) => _buildItem(context, index),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    // Header
    if (header != null && index == 0) {
      return header!;
    }

    // Footer
    if (footer != null && index == _getItemCount() - 1) {
      return footer!;
    }

    // Adjust index for header
    final itemIndex = header != null ? index - 1 : index;

    // Handle footer case
    if (footer != null && itemIndex >= items.length) {
      return footer!;
    }

    return itemBuilder(context, items[itemIndex], itemIndex);
  }

  int _getItemCount() {
    int count = items.length;
    if (header != null) count++;
    if (footer != null) count++;
    return count;
  }
}
