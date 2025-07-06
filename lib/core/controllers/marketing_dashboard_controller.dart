import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Observable variables
  final RxList<ChartData> leadGenerationData = <ChartData>[].obs;
  final RxList<MarketingCampaign> activeCampaigns = <MarketingCampaign>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTimePeriod = 'Last 7 Days'.obs;
  
  // Available time periods
  final List<String> timePeriods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last Year'
  ];

  @override
  void onInit() {
    super.onInit();
    loadMarketingData();
  }

  void loadMarketingData() {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      // Generate sample lead generation data
      leadGenerationData.value = [
        ChartData('Mon', 125, Colors.blue),
        ChartData('Tue', 189, Colors.green),
        ChartData('Wed', 95, Colors.orange),
        ChartData('Thu', 234, Colors.purple),
        ChartData('Fri', 178, Colors.red),
        ChartData('Sat', 67, Colors.teal),
        ChartData('Sun', 142, Colors.amber),
      ];
      
      // Generate sample marketing campaigns data
      activeCampaigns.value = [
        MarketingCampaign(
          'Summer Sale 2025', 
          'Social Media', 
          'Active', 
          25000, 
          18500, 
          4.2, 
          'High'
        ),
        MarketingCampaign(
          'Product Launch Campaign', 
          'Email Marketing', 
          'Active', 
          15000, 
          12300, 
          3.8, 
          'Medium'
        ),
        MarketingCampaign(
          'Brand Awareness Drive', 
          'Google Ads', 
          'Active', 
          30000, 
          22100, 
          5.1, 
          'High'
        ),
        MarketingCampaign(
          'Holiday Promotion', 
          'Influencer', 
          'Scheduled', 
          20000, 
          0, 
          0.0, 
          'Medium'
        ),
        MarketingCampaign(
          'Content Marketing Push', 
          'Blog & SEO', 
          'Active', 
          8000, 
          5900, 
          2.9, 
          'Low'
        ),
        MarketingCampaign(
          'Retargeting Campaign', 
          'Facebook Ads', 
          'Active', 
          12000, 
          9800, 
          6.2, 
          'High'
        ),
        MarketingCampaign(
          'Mobile App Promotion', 
          'App Store', 
          'Paused', 
          18000, 
          14200, 
          3.5, 
          'Medium'
        ),
        MarketingCampaign(
          'Webinar Series', 
          'LinkedIn', 
          'Active', 
          10000, 
          7500, 
          4.8, 
          'High'
        ),
      ];
      
      isLoading.value = false;
    });
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
        title: const Text('Contact Marketing Team'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 Email: marketing@syai.com'),
            SizedBox(height: 8),
            Text('📞 Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('🌐 Website: www.syai.com/marketing'),
            SizedBox(height: 8),
            Text('💬 Slack: #marketing-team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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

  MarketingCampaign(
    this.name, 
    this.channel, 
    this.status, 
    this.budget, 
    this.spent, 
    this.roi, 
    this.priority
  );

  double get remainingBudget => budget - spent;
  double get spentPercentage => spent / budget * 100;
}
