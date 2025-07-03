import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';

class MarketingCampaignsTable extends StatelessWidget {
  final RxList<MarketingCampaign> data;

  const MarketingCampaignsTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.isEmpty) {
        return Center(
          child: Text('no_campaigns_available'.tr),
        );
      }

      return DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 800,
        dataRowHeight: 64,
        headingRowHeight: 56,
        headingRowColor: WidgetStateColor.resolveWith(
          (states) => Get.theme.colorScheme.surfaceContainerHighest,
        ),
        columns: [
          DataColumn2(
            label: Text(
              'campaign_name'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text(
              'channel'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text(
              'status'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text(
              'budget'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.M,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'spent'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.M,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'roi'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'priority'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            size: ColumnSize.S,
          ),
        ],
        rows: data.map((campaign) {
          return DataRow2(
            cells: [
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            _getChannelColor(campaign.channel).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getChannelIcon(campaign.channel),
                        color: _getChannelColor(campaign.channel),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            campaign.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (campaign.spentPercentage > 0)
                            SizedBox(
                              width: 100,
                              child: LinearProgressIndicator(
                                value: campaign.spentPercentage / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getChannelColor(campaign.channel),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getChannelColor(campaign.channel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    campaign.channel,
                    style: TextStyle(
                      color: _getChannelColor(campaign.channel),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(campaign.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    campaign.status,
                    style: TextStyle(
                      color: _getStatusColor(campaign.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  '\$${_formatCurrency(campaign.budget)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${_formatCurrency(campaign.spent)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${campaign.spentPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      campaign.roi > 3.0
                          ? Icons.trending_up
                          : Icons.trending_flat,
                      color: campaign.roi > 3.0 ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${campaign.roi.toStringAsFixed(1)}x',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            campaign.roi > 3.0 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getPriorityColor(campaign.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    campaign.priority,
                    style: TextStyle(
                      color: _getPriorityColor(campaign.priority),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );
    });
  }

  Color _getChannelColor(String channel) {
    switch (channel.toLowerCase()) {
      case 'social media':
        return Colors.blue;
      case 'email marketing':
        return Colors.green;
      case 'google ads':
        return Colors.red;
      case 'influencer':
        return Colors.purple;
      case 'blog & seo':
        return Colors.orange;
      case 'facebook ads':
        return Colors.indigo;
      case 'app store':
        return Colors.cyan;
      case 'linkedin':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getChannelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'social media':
        return Icons.share;
      case 'email marketing':
        return Icons.email;
      case 'google ads':
        return Icons.search;
      case 'influencer':
        return Icons.person_pin;
      case 'blog & seo':
        return Icons.article;
      case 'facebook ads':
        return Icons.facebook;
      case 'app store':
        return Icons.apps;
      case 'linkedin':
        return Icons.business;
      default:
        return Icons.campaign;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
