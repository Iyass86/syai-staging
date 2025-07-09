import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class TypewriterController extends GetxController {
  final RxString displayText = ''.obs;
  final RxBool isTyping = false.obs;
  final RxBool isComplete = false.obs;

  Timer? _typingTimer;
  String _fullText = '';
  int _currentIndex = 0;

  // Typing speed - can be adjusted
  final Duration typingSpeed = const Duration(milliseconds: 30);

  @override
  void onClose() {
    _typingTimer?.cancel();
    super.onClose();
  }

  void startTyping(String text) {
    if (text.isEmpty) return;

    _fullText = text;
    _currentIndex = 0;
    displayText.value = '';
    isTyping.value = true;
    isComplete.value = false;

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(typingSpeed, (timer) {
      if (_currentIndex < _fullText.length) {
        displayText.value = _fullText.substring(0, _currentIndex + 1);
        _currentIndex++;
      } else {
        timer.cancel();
        isTyping.value = false;
        isComplete.value = true;
      }
    });
  }

  void stopTyping() {
    _typingTimer?.cancel();
    if (_fullText.isNotEmpty) {
      displayText.value = _fullText;
      isTyping.value = false;
      isComplete.value = true;
    }
  }

  void reset() {
    _typingTimer?.cancel();
    displayText.value = '';
    _fullText = '';
    _currentIndex = 0;
    isTyping.value = false;
    isComplete.value = false;
  }
}

class TypewriterMessage extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool autoStart;
  final VoidCallback? onComplete;
  final Color? cursorColor;

  const TypewriterMessage({
    Key? key,
    required this.text,
    this.style,
    this.autoStart = true,
    this.onComplete,
    this.cursorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(TypewriterController(), tag: text.hashCode.toString());

    if (autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.startTyping(text);
      });
    }

    return Obx(() {
      return GestureDetector(
        onTap: () {
          if (controller.isTyping.value) {
            controller.stopTyping();
          }
        },
        child: RichText(
          text: TextSpan(
            text: controller.displayText.value,
            style: style ?? Theme.of(context).textTheme.bodyMedium,
            children: [
              if (controller.isTyping.value)
                WidgetSpan(
                  child: _buildCursor(context),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCursor(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value > 0.5 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 2,
            height: 16,
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              color: cursorColor ?? Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced message bubble with smooth animations
class AnimatedMessageBubble extends StatefulWidget {
  final Widget child;
  final bool isUser;
  final bool hasImage;
  final Duration delay;

  const AnimatedMessageBubble({
    Key? key,
    required this.child,
    this.isUser = false,
    this.hasImage = false,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.isUser ? const Offset(0.3, 0) : const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// Enhanced thinking indicator with better animations
class EnhancedThinkingIndicator extends StatefulWidget {
  final Color color;
  final String text;
  final double size;

  const EnhancedThinkingIndicator({
    Key? key,
    required this.color,
    this.text = 'SyAi يفكر...',
    this.size = 8.0,
  }) : super(key: key);

  @override
  State<EnhancedThinkingIndicator> createState() =>
      _EnhancedThinkingIndicatorState();
}

class _EnhancedThinkingIndicatorState extends State<EnhancedThinkingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeInOut,
        ),
      ));
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color
                        .withOpacity(0.3 + 0.7 * _animations[index].value),
                    borderRadius: BorderRadius.circular(widget.size / 2),
                  ),
                );
              },
            );
          }),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Smooth image loading with fade in effect
class SmoothImageLoader extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SmoothImageLoader({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<SmoothImageLoader> createState() => _SmoothImageLoaderState();
}

class _SmoothImageLoaderState extends State<SmoothImageLoader> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Loading placeholder
        if (!_isLoaded)
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),

        // Actual image
        AnimatedOpacity(
          opacity: _isLoaded ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Image.network(
            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _isLoaded = true;
                    });
                  }
                });
                return child;
              }
              return const SizedBox.shrink();
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
