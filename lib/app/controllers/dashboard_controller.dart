import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  // Observable variables
  final RxList<ChartData> leadGenerationData = <ChartData>[].obs;
  final RxList<MarketingCampaign> activeCampaigns = <MarketingCampaign>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTimePeriod = 'last_7_days'.obs;

  // Dashboard view state - default to overview
  final RxString currentView = 'overview'.obs;

  // URL parameter handling
  final RxString urlDate = ''.obs;
  final RxString urlKpiData = ''.obs;
  final RxBool hasUrlParameters = false.obs;

  // Storage instance
  final GetStorage _storage = GetStorage();
  static const String _currentViewKey = 'dashboard_current_view';

  // KPI Data
  final RxList<KpiData> marketingKpis = <KpiData>[].obs;

  // Available time periods - using translation keys
  List<String> get timePeriods =>
      ['last_7_days', 'last_30_days_period', 'last_3_months', 'last_year'];

  // Dashboard view types
  static const String OVERVIEW_VIEW = 'overview';
  static const String SOCIAL_MEDIA_VIEW = 'social_media';

  @override
  void onInit() {
    super.onInit();
    _loadSavedView();
    _handleUrlParameters();
    loadMarketingData();
  }

  // Handle URL parameters
  void _handleUrlParameters() {
    final parameters = Get.parameters;

    // Handle date parameter
    if (parameters.containsKey('date')) {
      urlDate.value = parameters['date']!;
      hasUrlParameters.value = true;
    }

    // Handle KPI data parameters
    if (parameters.containsKey('leads')) {
      final leads = parameters['leads']!;
      _updateKpiFromUrl('total_leads', leads);
      hasUrlParameters.value = true;
    }

    if (parameters.containsKey('conversion_rate')) {
      final conversionRate = parameters['conversion_rate']!;
      _updateKpiFromUrl('conversion_rate', '$conversionRate%');
      hasUrlParameters.value = true;
    }

    if (parameters.containsKey('cost_per_lead')) {
      final costPerLead = parameters['cost_per_lead']!;
      _updateKpiFromUrl('cost_per_lead', '\$$costPerLead');
      hasUrlParameters.value = true;
    }

    if (parameters.containsKey('ad_spend')) {
      final adSpend = parameters['ad_spend']!;
      _updateKpiFromUrl('ad_spend', '\$$adSpend');
      hasUrlParameters.value = true;
    }

    if (parameters.containsKey('roi')) {
      final roi = parameters['roi']!;
      _updateKpiFromUrl('roi', '${roi}x');
      hasUrlParameters.value = true;
    }
  }

  // Update specific KPI from URL parameter
  void _updateKpiFromUrl(String kpiKey, String value) {
    // This will be used when loading marketing data to override specific KPIs
    urlKpiData.value = '$kpiKey:$value;${urlKpiData.value}';
  }

  // Load saved view from storage
  void _loadSavedView() {
    final savedView = _storage.read(_currentViewKey);
    if (savedView != null &&
        (savedView == OVERVIEW_VIEW || savedView == SOCIAL_MEDIA_VIEW)) {
      currentView.value = savedView;
    }
  }

  // Save current view to storage
  void _saveCurrentView() {
    _storage.write(_currentViewKey, currentView.value);
  }

  void loadMarketingData() {
    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      // Generate sample lead generation data
      leadGenerationData.value = [
        ChartData('monday'.tr, 0, Colors.blue),
        ChartData('tuesday'.tr, 0, Colors.green),
        ChartData('wednesday'.tr, 0, Colors.orange),
        ChartData('thursday'.tr, 0, Colors.purple),
        ChartData('friday'.tr, 0, Colors.red),
        ChartData('saturday'.tr, 0, Colors.teal),
        ChartData('sunday'.tr, 0, Colors.amber),
      ];

      // Generate sample marketing campaigns data
      activeCampaigns.value = [
        MarketingCampaign('summer_sale_2025'.tr, 'channel_social_media'.tr,
            'active'.tr, 0, 0, 0.0, 'high'.tr),
        MarketingCampaign('product_launch_campaign'.tr,
            'channel_email_marketing'.tr, 'active'.tr, 0, 0, 0.0, 'medium'.tr),
        MarketingCampaign('brand_awareness_drive'.tr, 'channel_google_ads'.tr,
            'active'.tr, 0, 0, 0.0, 'high'.tr),
        MarketingCampaign('holiday_promotion'.tr, 'channel_influencer'.tr,
            'scheduled'.tr, 0, 0, 0.0, 'medium'.tr),
        MarketingCampaign('content_marketing_push'.tr, 'blog_seo'.tr,
            'active'.tr, 0, 0, 0.0, 'low'.tr),
        MarketingCampaign('retargeting_campaign'.tr, 'channel_facebook_ads'.tr,
            'active'.tr, 0, 0, 0.0, 'high'.tr),
        MarketingCampaign('mobile_app_promotion'.tr, 'channel_app_store'.tr,
            'paused'.tr, 0, 0, 0.0, 'medium'.tr),
        MarketingCampaign('webinar_series'.tr, 'channel_linkedin'.tr,
            'active'.tr, 0, 0, 0.0, 'high'.tr),
      ];

      // Generate comprehensive KPI data with URL parameter overrides
      marketingKpis.value = _generateKpiData();

      isLoading.value = false;
    });
  }

  // Generate KPI data with URL parameter overrides
  List<KpiData> _generateKpiData() {
    final parameters = Get.parameters;

    // Default KPI values (all set to 0)
    String totalLeads = '0';
    String conversionRate = '0%';
    String costPerLead = '\$0';
    String activeCampaignsCount = '0';
    String adSpend = '\$0';
    String emailOpenRate = '0%';
    String socialReach = '0';
    String websiteTraffic = '0';
    String roi = '0x';
    String leadQualityScore = '0/10';
    String customerAcquisition = '0';
    String revenueImpact = '\$0';

    // Override with URL parameters if available
    if (parameters.containsKey('leads')) {
      totalLeads = _formatNumber(parameters['leads']!);
    }
    if (parameters.containsKey('conversion_rate')) {
      conversionRate = '${parameters['conversion_rate']}%';
    }
    if (parameters.containsKey('cost_per_lead')) {
      costPerLead = '\$${parameters['cost_per_lead']}';
    }
    if (parameters.containsKey('campaigns')) {
      activeCampaignsCount = parameters['campaigns']!;
    }
    if (parameters.containsKey('ad_spend')) {
      adSpend = '\$${_formatNumber(parameters['ad_spend']!)}';
    }
    if (parameters.containsKey('email_open_rate')) {
      emailOpenRate = '${parameters['email_open_rate']}%';
    }
    if (parameters.containsKey('social_reach')) {
      socialReach = _formatNumber(parameters['social_reach']!);
    }
    if (parameters.containsKey('website_traffic')) {
      websiteTraffic = _formatNumber(parameters['website_traffic']!);
    }
    if (parameters.containsKey('roi')) {
      roi = '${parameters['roi']}x';
    }
    if (parameters.containsKey('lead_quality')) {
      leadQualityScore = '${parameters['lead_quality']}/10';
    }
    if (parameters.containsKey('new_customers')) {
      customerAcquisition = parameters['new_customers']!;
    }
    if (parameters.containsKey('revenue')) {
      revenueImpact = '\$${_formatNumber(parameters['revenue']!)}';
    }

    return [
      KpiData('total_leads'.tr, totalLeads, 'this_month'.tr, Icons.person_add,
          Colors.blue, '0%', true),
      KpiData('conversion_rate'.tr, conversionRate, 'avg_monthly'.tr,
          Icons.trending_up, Colors.green, '0%', true),
      KpiData('cost_per_lead'.tr, costPerLead, 'current_average'.tr,
          Icons.monetization_on, Colors.orange, '\$0', true),
      KpiData('active_campaigns'.tr, activeCampaignsCount,
          'currently_running'.tr, Icons.campaign, Colors.purple, '0', true),
      KpiData('ad_spend'.tr, adSpend, 'this_month'.tr, Icons.credit_card,
          Colors.red, '0%', true),
      KpiData('email_open_rate'.tr, emailOpenRate, 'last_30_days'.tr,
          Icons.email, Colors.teal, '0%', true),
      KpiData('social_reach'.tr, socialReach, 'total_followers'.tr, Icons.share,
          Colors.indigo, '0', true),
      KpiData('website_traffic'.tr, websiteTraffic, 'monthly_visitors'.tr,
          Icons.visibility, Colors.cyan, '0%', true),
      KpiData('roi'.tr, roi, 'return_on_investment'.tr, Icons.savings,
          Colors.green, '0x', true),
      KpiData('lead_quality_score'.tr, leadQualityScore, 'average_rating'.tr,
          Icons.star, Colors.amber, '0', true),
      KpiData(
          'customer_acquisition'.tr,
          customerAcquisition,
          'new_customers'.tr,
          Icons.person_add_alt,
          Colors.deepPurple,
          '0',
          true),
      KpiData('revenue_impact'.tr, revenueImpact, 'generated_revenue'.tr,
          Icons.attach_money, Colors.green, '0%', true),
    ];
  }

  // Helper method to format numbers with K/M suffixes
  String _formatNumber(String number) {
    try {
      final num = double.parse(number);
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(1)}K';
      } else {
        return num.toStringAsFixed(0);
      }
    } catch (e) {
      return number; // Return original if parsing fails
    }
  }

  void updateTimePeriod(String period) {
    selectedTimePeriod.value = period;
    loadMarketingData(); // Reload data for the new time period
  }

  void refreshData() {
    loadMarketingData();
  }

  void showContactUs() {
    Get.dialog(
      AlertDialog(
        title: Text('contact_marketing_team'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 ${'email'.tr}: ${'marketing_email'.tr}'),
            const SizedBox(height: 8),
            Text('📞 ${'phone'.tr}: ${'marketing_phone'.tr}'),
            const SizedBox(height: 8),
            Text('🌐 ${'website'.tr}: ${'marketing_website'.tr}'),
            const SizedBox(height: 8),
            Text('💬 ${'slack'.tr}: ${'marketing_slack'.tr}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  // Switch dashboard views with persistence
  void switchToOverview() {
    currentView.value = OVERVIEW_VIEW;
    _saveCurrentView();
  }

  void switchToSocialMedia() {
    currentView.value = SOCIAL_MEDIA_VIEW;
    _saveCurrentView();
  }

  // Get currently selected navigation item
  String getCurrentNavigationItem() {
    return currentView.value;
  }

  // Get URL parameter information for display
  String getUrlParameterInfo() {
    final parameters = Get.parameters;
    if (parameters.isEmpty) {
      return '';
    }

    List<String> paramInfo = [];

    if (parameters.containsKey('date')) {
      paramInfo.add('Date: ${parameters['date']}');
    }

    if (parameters.containsKey('leads')) {
      paramInfo.add('Leads: ${parameters['leads']}');
    }

    if (parameters.containsKey('conversion_rate')) {
      paramInfo.add('Conversion Rate: ${parameters['conversion_rate']}%');
    }

    if (parameters.containsKey('ad_spend')) {
      paramInfo.add('Ad Spend: \$${parameters['ad_spend']}');
    }

    if (parameters.containsKey('roi')) {
      paramInfo.add('ROI: ${parameters['roi']}x');
    }

    return paramInfo.join(' | ');
  }

  // Check if there are any URL parameters
  bool hasAnyUrlParameters() {
    return Get.parameters.isNotEmpty;
  }
}

class ChartData {
  final String category;
  final double value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}

class MarketingCampaign {
  final String name;
  final String channel;
  final String status;
  final double budget;
  final double spent;
  final double roi;
  final String priority;

  MarketingCampaign(this.name, this.channel, this.status, this.budget,
      this.spent, this.roi, this.priority);

  double get remainingBudget => budget - spent;
  double get spentPercentage => spent / budget * 100;
}

class KpiData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? isPositive;

  KpiData(
    this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.trend,
    this.isPositive,
  );
}
