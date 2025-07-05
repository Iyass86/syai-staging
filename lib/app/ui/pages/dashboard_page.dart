import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/ui/pages/social_media_page.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../controllers/dashboard_controller.dart';
import '../widgets/kpi_table.dart';
import '../widgets/app_navigation_helper.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppNavigationHelper.buildNavigationDrawer(),
      appBar: AppBar(
        title: Obx(() => Text(
              controller.currentView.value ==
                      DashboardController.SOCIAL_MEDIA_VIEW
                  ? 'social_media_dashboard'.tr
                  : 'marketing_dashboard'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Refresh button
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh_data'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Conditionally show different layouts based on current view
        if (controller.currentView.value ==
            DashboardController.SOCIAL_MEDIA_VIEW) {
          return const SocialMediaPage();
        }

        // Default overview layout
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // Time period selector
              _buildTimePeriodSelector(),
              const SizedBox(height: 24),

              // Key Marketing KPIs Table
              _buildKpiTable(),
              const SizedBox(height: 32),

              // Marketing Trends Chart
              //  _buildMarketingChart(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMarketingChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'marketing_trends_performance'.tr,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'weekly_lead_generation_trends'.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 16,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'trend_analysis'.tr,
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Chart content
            Obx(() {
              if (controller.leadGenerationData.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return SizedBox(
                height: 350,
                child: Row(
                  children: [
                    // Bar Chart for Lead Generation
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'lead_generation'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'daily_leads_generated'.tr,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 300,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (_) =>
                                        Get.theme.colorScheme.inverseSurface,
                                    tooltipRoundedRadius: 8,
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                        '${controller.leadGenerationData[group.x.toInt()].category}\n${rod.toY.round()} leads',
                                        TextStyle(
                                          color: Get.theme.colorScheme
                                              .onInverseSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() <
                                                controller.leadGenerationData
                                                    .length) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              controller
                                                  .leadGenerationData[
                                                      value.toInt()]
                                                  .category,
                                              style: Get.textTheme.bodySmall,
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 45,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: Get.textTheme.bodySmall,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Get.theme.colorScheme.outline
                                          .withOpacity(0.2),
                                    ),
                                    left: BorderSide(
                                      color: Get.theme.colorScheme.outline
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                barGroups: controller.leadGenerationData
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final data = entry.value;
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.value,
                                        color: data.color,
                                        width: 22,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(4),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            data.color,
                                            data.color.withOpacity(0.7),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 50,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Get.theme.colorScheme.outline
                                          .withOpacity(0.1),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Pie Chart for Campaign Performance
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'campaign_performance'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'roi_distribution_by_channel'.tr,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 50,
                                sections: _getPieChartSections(),
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    // Handle touch events if needed
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPieChartLegend(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Key insights section
            _buildKeyInsights(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final activeCampaigns =
        controller.activeCampaigns.where((c) => c.status == 'Active').toList();

    final channelData = <String, double>{};
    final channelColors = <String, Color>{
      'channel_social_media'.tr: Colors.blue,
      'channel_email_marketing'.tr: Colors.green,
      'channel_google_ads'.tr: Colors.orange,
      'channel_facebook_ads'.tr: Colors.purple,
      'channel_linkedin'.tr: Colors.indigo,
      'Blog & SEO': Colors.teal,
      'channel_app_store'.tr: Colors.red,
      'channel_other'.tr: Colors.grey,
    };

    for (final campaign in activeCampaigns) {
      channelData[campaign.channel] =
          (channelData[campaign.channel] ?? 0) + campaign.roi;
    }

    return channelData.entries.map((entry) {
      final percentage =
          (entry.value / channelData.values.reduce((a, b) => a + b)) * 100;
      return PieChartSectionData(
        color: channelColors[entry.key] ?? Colors.grey,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: Get.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildPieChartLegend() {
    final activeCampaigns =
        controller.activeCampaigns.where((c) => c.status == 'Active').toList();
    final channelData = <String, double>{};
    final channelColors = <String, Color>{
      'channel_social_media'.tr: Colors.blue,
      'channel_email_marketing'.tr: Colors.green,
      'channel_google_ads'.tr: Colors.orange,
      'channel_facebook_ads'.tr: Colors.purple,
      'channel_linkedin'.tr: Colors.indigo,
      'Blog & SEO': Colors.teal,
      'channel_app_store'.tr: Colors.red,
      'channel_other'.tr: Colors.grey,
    };

    for (final campaign in activeCampaigns) {
      channelData[campaign.channel] =
          (channelData[campaign.channel] ?? 0) + campaign.roi;
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: channelData.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: channelColors[entry.key] ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              entry.key,
              style: Get.textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildKeyInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Get.theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'key_insights'.tr,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final totalLeads = controller.leadGenerationData.fold<double>(
              0,
              (sum, data) => sum + data.value,
            );
            final avgDailyLeads =
                totalLeads / controller.leadGenerationData.length;
            final bestDay = controller.leadGenerationData
                .reduce((a, b) => a.value > b.value ? a : b);
            final activeCampaignCount = controller.activeCampaigns
                .where((c) => c.status == 'Active')
                .length;

            return Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildInsightItem(
                  Icons.trending_up,
                  'best_performance_day'.tr,
                  '${bestDay.category} (${bestDay.value.toInt()} leads)',
                  Colors.green,
                ),
                _buildInsightItem(
                  Icons.bar_chart,
                  'daily_average'.tr,
                  '${avgDailyLeads.toStringAsFixed(0)} leads/day',
                  Colors.blue,
                ),
                _buildInsightItem(
                  Icons.campaign,
                  'active_campaigns'.tr,
                  '$activeCampaignCount running',
                  Colors.orange,
                ),
                _buildInsightItem(
                  Icons.timeline,
                  'trend_direction'.tr,
                  totalLeads > 1000 ? 'strong_growth'.tr : 'steady_progress'.tr,
                  Colors.purple,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
      IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Get.theme.colorScheme.primary.withOpacity(0.1),
              Get.theme.colorScheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcome_marketing_hub'.tr,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'marketing_hub_description'.tr,
              style: Get.textTheme.bodyLarge?.copyWith(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            // Display URL parameters if any
            Obx(() {
              if (controller.hasUrlParameters.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Get.theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: Get.theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'URL Parameters',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.getUrlParameterInfo(),
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Row(
      children: [
        Text(
          '${'time_period'.tr}:',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Obx(() => DropdownButton<String>(
              value: controller.selectedTimePeriod.value,
              onChanged: (value) {
                if (value != null) {
                  controller.updateTimePeriod(value);
                }
              },
              items: controller.timePeriods.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(period.tr),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildKpiTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'marketing_performance_overview'.tr,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'kpi_for_marketing_operations'.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: Get.theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'performance_meeting'.tr,
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // KPI Table
            Obx(() {
              if (controller.marketingKpis.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(
                height: 844,
                child: KpiTable(data: controller.marketingKpis),
              );
            }),
          ],
        ),
      ),
    );
  }
}
