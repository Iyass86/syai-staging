import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';

class KpiTable extends StatelessWidget {
  final RxList<KpiData> data;

  const KpiTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return DataTable2(
        columnSpacing: 20,
        horizontalMargin: 24,
        minWidth: 800,
        dataRowHeight: 64,
        headingRowHeight: 56,
        headingRowColor: WidgetStateColor.resolveWith(
          (states) => Get.theme.colorScheme.surfaceContainerHighest,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        columns: [
          DataColumn2(
            label: Text(
              'kpi_metric'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text(
              'current_value'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.M,
            numeric: false,
          ),
          DataColumn2(
            label: Text(
              'time_period'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text(
              'monthly_change'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text(
              'status'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            size: ColumnSize.S,
          ),
        ],
        rows: data.map((kpi) {
          return DataRow2(
            cells: [
              // KPI Metric column with icon
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kpi.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        kpi.icon,
                        color: kpi.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        kpi.title.tr,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Current Value column
              DataCell(
                Text(
                  kpi.value,
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kpi.color,
                  ),
                ),
              ),

              // Period column
              DataCell(
                Text(
                  kpi.subtitle,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),

              // Monthly Change column with visual indicators
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTrendColor(kpi.isPositive).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getTrendColor(kpi.isPositive).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTrendIcon(kpi.isPositive),
                        size: 16,
                        color: _getTrendColor(kpi.isPositive),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        kpi.trend ?? 'N/A',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getTrendColor(kpi.isPositive),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Status column
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(kpi).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusText(kpi),
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(kpi),
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

  Color _getTrendColor(bool? isPositive) {
    if (isPositive == null) return Colors.grey;
    return isPositive ? Colors.green : Colors.red;
  }

  IconData _getTrendIcon(bool? isPositive) {
    if (isPositive == null) return Icons.remove;
    return isPositive ? Icons.trending_up : Icons.trending_down;
  }

  Color _getStatusColor(KpiData kpi) {
    // Determine status color based on the metric type and performance
    if (kpi.isPositive == true) {
      return Colors.green;
    } else if (kpi.isPositive == false) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  String _getStatusText(KpiData kpi) {
    // Determine status text based on performance
    if (kpi.isPositive == true) {
      return 'improving'.tr;
    } else if (kpi.isPositive == false) {
      return 'declining'.tr;
    } else {
      return 'stable'.tr;
    }
  }
}
