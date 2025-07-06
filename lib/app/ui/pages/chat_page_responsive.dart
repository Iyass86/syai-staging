import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/theme_toggle_button.dart';

class ChatPageResponsive extends GetView<ChatController> {
  const ChatPageResponsive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet =
              constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
          final isMobile = constraints.maxWidth <= 768;

          return Obx(() {
            // ChatGPT-like layout: centered input when empty, normal layout when messages exist
            if (controller.messages.isEmpty) {
              return _buildEmptyStateLayout(
                  colorScheme, isDesktop, isTablet, isMobile);
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildLoadingStatus(colorScheme),
                      Expanded(child: _buildMessagesList(colorScheme)),
                      _buildMessageInputCard(
                          colorScheme, isDesktop, isTablet, isMobile),
                    ],
                  ),
                  // Floating suggestions button
                  _buildFloatingSuggestions(
                      colorScheme, isDesktop, isTablet, isMobile),
                ],
              );
            }
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'syai_chat'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Obx(() {
              final user = controller.authController.currentUser.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user != null ? Colors.green : colorScheme.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user?.userMetadata?['name'] ?? 'unknown_user'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: colorScheme.onSurface),
          onPressed: controller.refreshMessages,
          tooltip: 'refresh_messages'.tr,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
          ),
        ),
        const ThemeToggleButton(),
        IconButton(
          icon: Icon(Icons.logout, color: colorScheme.error),
          onPressed: () => _showLogoutDialog(),
          tooltip: 'logout'.tr,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.error,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyStateLayout(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Stack(
      children: [
        // Background with welcome content
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? 48
                  : isTablet
                      ? 32
                      : 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop
                    ? 1000
                    : isTablet
                        ? 800
                        : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo/icon
                  Container(
                    width: isDesktop
                        ? 100
                        : isTablet
                            ? 90
                            : 80,
                    height: isDesktop
                        ? 100
                        : isTablet
                            ? 90
                            : 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology_alt_rounded,
                      size: isDesktop
                          ? 50
                          : isTablet
                              ? 45
                              : 40,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(
                      height: isDesktop
                          ? 40
                          : isTablet
                              ? 36
                              : 32),

                  // Welcome title
                  Text(
                    'Welcome to SyAi',
                    style: TextStyle(
                      fontSize: isDesktop
                          ? 40
                          : isTablet
                              ? 36
                              : 32,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(
                      height: isDesktop
                          ? 16
                          : isTablet
                              ? 14
                              : 12),

                  // Subtitle
                  Text(
                    'Your intelligent assistant is ready to help',
                    style: TextStyle(
                      fontSize: isDesktop
                          ? 20
                          : isTablet
                              ? 19
                              : 18,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: isDesktop
                          ? 56
                          : isTablet
                              ? 52
                              : 48),

                  // Marketing Campaign Suggestions
                  _buildMarketingCampaignSuggestions(
                      colorScheme, isDesktop, isTablet, isMobile),
                  SizedBox(
                      height: isDesktop
                          ? 40
                          : isTablet
                              ? 36
                              : 32),

                  // Quick Action Cards
                  _buildQuickActionCards(
                      colorScheme, isDesktop, isTablet, isMobile),
                  SizedBox(
                      height: isDesktop
                          ? 40
                          : isTablet
                              ? 36
                              : 32),

                  // Get Started Button
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isDesktop
                          ? 600
                          : isTablet
                              ? 500
                              : double.infinity,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: isDesktop
                          ? 64
                          : isTablet
                              ? 48
                              : 32,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _sendInitialAdAccountMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop
                              ? 32
                              : isTablet
                                  ? 28
                                  : 24,
                          vertical: isDesktop
                              ? 20
                              : isTablet
                                  ? 18
                                  : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(
                        Icons.rocket_launch_rounded,
                        size: isDesktop
                            ? 20
                            : isTablet
                                ? 18
                                : 16,
                      ),
                      label: Text(
                        'Get Started with Account Overview',
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 18
                              : isTablet
                                  ? 17
                                  : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: isDesktop
                          ? 140
                          : isTablet
                              ? 130
                              : 120), // Space for the input area
                ],
              ),
            ),
          ),
        ),

        // Centered input at bottom
        Positioned(
          left: isDesktop
              ? 48
              : isTablet
                  ? 32
                  : 16,
          right: isDesktop
              ? 48
              : isTablet
                  ? 32
                  : 16,
          bottom: 24,
          child:
              _buildCenteredInput(colorScheme, isDesktop, isTablet, isMobile),
        ),
      ],
    );
  }

  Widget _buildMarketingCampaignSuggestions(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    final campaignSuggestions = [
      {
        'icon': Icons.campaign_rounded,
        'title': 'Social Media Campaign',
        'subtitle': 'Create engaging social media content',
        'prompt':
            'Help me create a comprehensive social media marketing campaign for my business. I need ideas for posts, hashtags, and engagement strategies.',
        'color': Colors.purple,
      },
      {
        'icon': Icons.email_rounded,
        'title': 'Email Marketing',
        'subtitle': 'Design email sequences that convert',
        'prompt':
            'Create an email marketing campaign with subject lines, content templates, and follow-up sequences to increase customer engagement.',
        'color': Colors.blue,
      },
      {
        'icon': Icons.trending_up_rounded,
        'title': 'SEO Strategy',
        'subtitle': 'Optimize content for search engines',
        'prompt':
            'Develop an SEO strategy including keyword research, content optimization, and link building tactics for better search rankings.',
        'color': Colors.green,
      },
      {
        'icon': Icons.ads_click_rounded,
        'title': 'Ad Copy Generator',
        'subtitle': 'Write compelling ad copy',
        'prompt':
            'Generate high-converting ad copy for Google Ads, Facebook Ads, and other platforms with A/B testing variations.',
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 10 : 8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: colorScheme.primary,
                  size: isDesktop
                      ? 24
                      : isTablet
                          ? 22
                          : 20,
                ),
              ),
              SizedBox(width: isDesktop ? 16 : 12),
              Text(
                'Marketing Campaign Ideas',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 22
                      : isTablet
                          ? 20
                          : 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 20 : 16),
        SizedBox(
          height: isDesktop
              ? 220
              : isTablet
                  ? 200
                  : 180,
          child: isMobile
              ? PageView.builder(
                  padEnds: false,
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: campaignSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = campaignSuggestions[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildCampaignCard(suggestion, colorScheme,
                          isDesktop, isTablet, isMobile),
                    );
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 8),
                  itemCount: campaignSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = campaignSuggestions[index];
                    return Container(
                      width: isDesktop
                          ? 260
                          : isTablet
                              ? 220
                              : 180,
                      margin: EdgeInsets.only(right: isDesktop ? 24 : 16),
                      child: _buildCampaignCard(suggestion, colorScheme,
                          isDesktop, isTablet, isMobile),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> suggestion,
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return GestureDetector(
      onTap: () {
        controller.messageController.text = suggestion['prompt'] as String;
        controller.sendMessage();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (suggestion['color'] as Color).withOpacity(0.1),
              (suggestion['color'] as Color).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (suggestion['color'] as Color).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (suggestion['color'] as Color).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isDesktop
              ? 24
              : isTablet
                  ? 20
                  : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop
                    ? 14
                    : isTablet
                        ? 12
                        : 10),
                decoration: BoxDecoration(
                  color: (suggestion['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  suggestion['icon'] as IconData,
                  color: suggestion['color'] as Color,
                  size: isDesktop
                      ? 28
                      : isTablet
                          ? 26
                          : 24,
                ),
              ),
              SizedBox(
                  height: isDesktop
                      ? 18
                      : isTablet
                          ? 16
                          : 12),
              Text(
                suggestion['title'] as String,
                style: TextStyle(
                  fontSize: isDesktop
                      ? 18
                      : isTablet
                          ? 16
                          : 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(
                  height: isDesktop
                      ? 10
                      : isTablet
                          ? 8
                          : 6),
              Text(
                suggestion['subtitle'] as String,
                style: TextStyle(
                  fontSize: isDesktop
                      ? 14
                      : isTablet
                          ? 13
                          : 12,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? 14
                      : isTablet
                          ? 12
                          : 10,
                  vertical: isDesktop
                      ? 8
                      : isTablet
                          ? 6
                          : 5,
                ),
                decoration: BoxDecoration(
                  color: (suggestion['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Try it',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 13
                            : isTablet
                                ? 12
                                : 11,
                        fontWeight: FontWeight.w600,
                        color: suggestion['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: suggestion['color'] as Color,
                      size: isDesktop
                          ? 16
                          : isTablet
                              ? 14
                              : 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCards(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    final quickActions = [
      {
        'icon': Icons.analytics_rounded,
        'title': 'Account Analysis',
        'subtitle': 'Get insights about your ad accounts',
        'prompt':
            'Analyze my advertising account data and provide insights on performance, budget optimization, and recommendations for improvement.',
      },
      {
        'icon': Icons.group_rounded,
        'title': 'Audience Targeting',
        'subtitle': 'Define your target audience',
        'prompt':
            'Help me define and create detailed audience personas for my marketing campaigns, including demographics, interests, and behaviors.',
      },
      {
        'icon': Icons.content_copy_rounded,
        'title': 'Content Calendar',
        'subtitle': 'Plan your content strategy',
        'prompt':
            'Create a 30-day content calendar with post ideas, captions, and optimal posting times for my social media channels.',
      },
      {
        'icon': Icons.psychology_rounded,
        'title': 'Creative Ideas',
        'subtitle': 'Brainstorm campaign concepts',
        'prompt':
            'Generate creative marketing campaign ideas with unique angles, storytelling approaches, and innovative concepts for my brand.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 10 : 8),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.flash_on_rounded,
                  color: colorScheme.secondary,
                  size: isDesktop
                      ? 24
                      : isTablet
                          ? 22
                          : 20,
                ),
              ),
              SizedBox(width: isDesktop ? 16 : 12),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 22
                      : isTablet
                          ? 20
                          : 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 20 : 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop
                ? 4
                : isTablet
                    ? 2
                    : 2,
            crossAxisSpacing: isDesktop
                ? 20
                : isTablet
                    ? 16
                    : 12,
            mainAxisSpacing: isDesktop
                ? 20
                : isTablet
                    ? 16
                    : 12,
            childAspectRatio: isDesktop
                ? 1.3
                : isTablet
                    ? 1.2
                    : 1.1,
          ),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            final action = quickActions[index];
            return GestureDetector(
              onTap: () {
                controller.messageController.text = action['prompt'] as String;
                controller.sendMessage();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop
                      ? 20
                      : isTablet
                          ? 18
                          : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDesktop
                            ? 12
                            : isTablet
                                ? 11
                                : 10),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: colorScheme.primary,
                          size: isDesktop
                              ? 24
                              : isTablet
                                  ? 22
                                  : 20,
                        ),
                      ),
                      SizedBox(
                          height: isDesktop
                              ? 16
                              : isTablet
                                  ? 14
                                  : 12),
                      Text(
                        action['title'] as String,
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 6 : 4),
                      Text(
                        action['subtitle'] as String,
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 13
                              : isTablet
                                  ? 12
                                  : 11,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCenteredInput(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop
            ? 1000
            : isTablet
                ? 800
                : double.infinity,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 24
                : isTablet
                    ? 22
                    : 20,
            vertical: isDesktop
                ? 20
                : isTablet
                    ? 18
                    : 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Typing indicator for empty state
              Obx(() {
                if (controller.isWaitingForResponse.value) {
                  return Container(
                    margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 18 : 16,
                      vertical: isDesktop ? 10 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: isDesktop ? 18 : 16,
                          height: isDesktop ? 18 : 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 10 : 8),
                        Text(
                          'SyAi is thinking...',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8),
                            fontSize: isDesktop
                                ? 16
                                : isTablet
                                    ? 15
                                    : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Input row
              Row(
                children: [
                  Obx(() => IconButton(
                        icon: controller.isUploadingImage.value
                            ? SizedBox(
                                width: isDesktop ? 22 : 20,
                                height: isDesktop ? 22 : 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            : Icon(
                                Icons.attach_file_rounded,
                                color: colorScheme.onSurface.withOpacity(0.6),
                                size: isDesktop
                                    ? 24
                                    : isTablet
                                        ? 22
                                        : 20,
                              ),
                        onPressed: controller.isUploadingImage.value
                            ? null
                            : controller.pickAndUploadImage,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(isDesktop ? 12 : 10),
                        ),
                      )),
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Message SyAi...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: isDesktop
                              ? 18
                              : isTablet
                                  ? 17
                                  : 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isDesktop
                              ? 20
                              : isTablet
                                  ? 18
                                  : 16,
                          vertical: isDesktop
                              ? 16
                              : isTablet
                                  ? 14
                                  : 12,
                        ),
                      ),
                      maxLines: 6,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: isDesktop
                            ? 18
                            : isTablet
                                ? 17
                                : 16,
                      ),
                    ),
                  ),
                  Obx(() => Container(
                        margin: EdgeInsets.only(left: isDesktop ? 12 : 8),
                        child: IconButton(
                          onPressed: controller.isWaitingForResponse.value
                              ? null
                              : controller.sendMessage,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                controller.isWaitingForResponse.value
                                    ? colorScheme.surfaceContainerHighest
                                    : colorScheme.primary,
                            foregroundColor:
                                controller.isWaitingForResponse.value
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(isDesktop
                                ? 16
                                : isTablet
                                    ? 14
                                    : 12),
                          ),
                          icon: controller.isWaitingForResponse.value
                              ? SizedBox(
                                  width: isDesktop ? 22 : 20,
                                  height: isDesktop ? 22 : 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_upward_rounded,
                                  size: isDesktop
                                      ? 24
                                      : isTablet
                                          ? 22
                                          : 20,
                                ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSuggestions(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Positioned(
      right: isDesktop
          ? 32
          : isTablet
              ? 24
              : 16,
      bottom: isDesktop
          ? 120
          : isTablet
              ? 110
              : 100,
      child: Obx(() {
        // Only show if there are messages and not waiting for response
        if (controller.messages.isEmpty ||
            controller.isWaitingForResponse.value) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () => _showQuickSuggestions(colorScheme),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          elevation: 4,
          icon: Icon(
            Icons.lightbulb_outline,
            size: isDesktop
                ? 22
                : isTablet
                    ? 20
                    : 18,
          ),
          label: Text(
            'Suggestions',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isDesktop
                  ? 16
                  : isTablet
                      ? 15
                      : 14,
            ),
          ),
        );
      }),
    );
  }

  void _showQuickSuggestions(ColorScheme colorScheme) {
    final suggestions = [
      'Show me my ad account performance data',
      'Create a new campaign strategy',
      'Analyze my audience demographics',
      'Optimize my current campaigns',
      'Generate creative ad copy variations',
      'Suggest budget reallocation',
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Suggestions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Suggestions list
            ...suggestions
                .map((suggestion) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.messageController.text = suggestion;
                            controller.sendMessage();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorScheme.onSurface.withOpacity(0.4),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // Method to send initial ad account data message
  void _sendInitialAdAccountMessage() {
    // Add the welcome message to the chat
    controller.messageController.text =
        'Show me my ad account overview with performance data, active campaigns, and optimization recommendations';
    controller.sendMessage();
  }

  Widget _buildLoadingStatus(ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.1),
                    colorScheme.primaryContainer.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading messages...',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMessagesList(ColorScheme colorScheme) {
    return Obx(() {
      return Container(
        color: colorScheme.surface,
        child: ChatMessageList(
          controller: controller,
          scrollController: controller.scrollController,
          messages: controller.messages,
          isWaitingForResponse: controller.isWaitingForResponse.value,
        ),
      );
    });
  }

  Widget _buildMessageInputCard(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Card(
      margin: EdgeInsets.all(isDesktop
          ? 24
          : isTablet
              ? 20
              : 16),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isDesktop
              ? 20
              : isTablet
                  ? 18
                  : 16),
          child: Column(
            children: [
              // Typing indicator
              Obx(() {
                if (controller.isWaitingForResponse.value) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 16 : 12,
                      vertical: isDesktop ? 10 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: isDesktop ? 18 : 16,
                          height: isDesktop ? 18 : 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 10 : 8),
                        Text(
                          'SyAi is typing...',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8),
                            fontSize: isDesktop
                                ? 16
                                : isTablet
                                    ? 15
                                    : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              // Input row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() => IconButton(
                        icon: controller.isUploadingImage.value
                            ? SizedBox(
                                width: isDesktop ? 22 : 20,
                                height: isDesktop ? 22 : 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            : Icon(
                                Icons.attach_file,
                                color: colorScheme.onSurface.withOpacity(0.6),
                                size: isDesktop
                                    ? 24
                                    : isTablet
                                        ? 22
                                        : 20,
                              ),
                        onPressed: controller.isUploadingImage.value
                            ? null
                            : controller.pickAndUploadImage,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                  if (!isMobile) ...[
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: colorScheme.onSurface.withOpacity(0.6),
                        size: isDesktop
                            ? 24
                            : isTablet
                                ? 22
                                : 20,
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'coming_soon'.tr,
                          'Emoji picker will be available soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: colorScheme.primaryContainer,
                          colorText: colorScheme.onPrimaryContainer,
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: isDesktop
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isDesktop
                              ? 20
                              : isTablet
                                  ? 18
                                  : 16,
                          vertical: isDesktop
                              ? 16
                              : isTablet
                                  ? 14
                                  : 12,
                        ),
                        isDense: true,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: isDesktop
                            ? 16
                            : isTablet
                                ? 15
                                : 14,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: isDesktop
                          ? 16
                          : isTablet
                              ? 14
                              : 12),
                  Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: FloatingActionButton(
                          onPressed: controller.isWaitingForResponse.value
                              ? null
                              : controller.sendMessage,
                          elevation:
                              controller.isWaitingForResponse.value ? 1 : 3,
                          mini: !isDesktop,
                          backgroundColor: controller.isWaitingForResponse.value
                              ? colorScheme.surfaceContainerHighest
                              : colorScheme.primary,
                          child: controller.isWaitingForResponse.value
                              ? SizedBox(
                                  width: isDesktop ? 24 : 20,
                                  height: isDesktop ? 24 : 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.send,
                                  color: colorScheme.onPrimary,
                                  size: isDesktop ? 24 : 20,
                                ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final colorScheme = Theme.of(Get.context!).colorScheme;

    Get.dialog(
      AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withOpacity(0.7),
            ),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
