import 'dart:convert';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class ExportService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd_HH-mm-ss');

  /// Test function to check if export service is working
  static Future<void> testExport() async {
    try {
      print('Testing export service...');

      // Test simple JSON download
      final testData = {
        'test': 'data',
        'timestamp': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(testData);
      final filename = 'test_export_${_dateFormat.format(DateTime.now())}.json';

      print('Attempting to download test file: $filename');
      _downloadFile(filename, 'application/json', content: jsonString);
      print('Test export completed successfully');
    } catch (e) {
      print('Test export failed: $e');
      rethrow;
    }
  }

  /// Export dashboard data as XLSX
  static Future<void> exportAsXLSX() async {
    print('Starting XLSX export...');
    try {
      // Get controller with error handling
      late DashboardController controller;
      try {
        controller = Get.find<DashboardController>();
        print('DashboardController found successfully');
      } catch (e) {
        print('Failed to find DashboardController: $e');
        throw Exception(
            'Dashboard controller not found. Please make sure the dashboard is loaded first.');
      }

      if (controller.marketingKpis.isEmpty &&
          controller.activeCampaigns.isEmpty &&
          controller.leadGenerationData.isEmpty) {
        print('No data available for export');
        throw Exception('No data available for export');
      }

      print(
          'Data available: KPIs: ${controller.marketingKpis.length}, Campaigns: ${controller.activeCampaigns.length}, Leads: ${controller.leadGenerationData.length}');

      // Create Excel workbook
      print('Creating Excel workbook...');
      var excel = Excel.createExcel();

      // Remove default sheet - use proper method
      try {
        // First create our sheets, then remove default if it exists
        excel['KPI_Data']; // Create the sheet
        excel['Campaigns']; // Create the sheet
        excel['Lead_Generation']; // Create the sheet

        // Now try to remove the default sheet if it exists
        var sheetNames = excel.sheets.keys.toList();
        print('Available sheets: $sheetNames');

        if (sheetNames.contains('Sheet1')) {
          excel.delete('Sheet1');
          print('Default Sheet1 removed successfully');
        } else {
          print('No Sheet1 found to remove');
        }
      } catch (e) {
        print('Warning: Could not remove default sheet: $e');
        // Continue without removing - it's not critical
      }

      // Get sheet references
      print('Creating KPI sheet...');
      var kpiSheet = excel['KPI_Data'];

      // Add KPI headers
      var kpiHeaders = [
        'KPI Title',
        'Value',
        'Subtitle',
        'Trend',
        'Is Positive'
      ];

      try {
        for (int i = 0; i < kpiHeaders.length; i++) {
          kpiSheet
              .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
              .value = TextCellValue(kpiHeaders[i]);
        }
        print('KPI headers added successfully');

        // Add KPI data
        for (int i = 0; i < controller.marketingKpis.length; i++) {
          var kpi = controller.marketingKpis[i];
          var rowIndex = i + 1;

          kpiSheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 0, rowIndex: rowIndex))
              .value = TextCellValue(kpi.title);
          kpiSheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 1, rowIndex: rowIndex))
              .value = TextCellValue(kpi.value);
          kpiSheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 2, rowIndex: rowIndex))
              .value = TextCellValue(kpi.subtitle);
          kpiSheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 3, rowIndex: rowIndex))
              .value = TextCellValue(kpi.trend ?? 'N/A');
          kpiSheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 4, rowIndex: rowIndex))
              .value = TextCellValue(kpi.isPositive?.toString() ?? 'N/A');
        }
        print(
            'KPI data added successfully (${controller.marketingKpis.length} rows)');
      } catch (e) {
        print('Error adding KPI data: $e');
        throw Exception('Failed to add KPI data to Excel sheet: $e');
      }

      // Create Campaigns sheet
      print('Adding campaign data...');
      var campaignSheet = excel['Campaigns'];

      // Add Campaign headers
      var campaignHeaders = [
        'Campaign Name',
        'Channel',
        'Status',
        'Budget',
        'Spent',
        'ROI',
        'Priority',
        'Remaining Budget',
        'Spent Percentage'
      ];

      for (int i = 0; i < campaignHeaders.length; i++) {
        campaignSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(campaignHeaders[i]);
      }

      // Add Campaign data
      for (int i = 0; i < controller.activeCampaigns.length; i++) {
        var campaign = controller.activeCampaigns[i];
        var rowIndex = i + 1;

        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(campaign.name);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(campaign.channel);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(campaign.status);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = DoubleCellValue(campaign.budget);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = DoubleCellValue(campaign.spent);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = DoubleCellValue(campaign.roi);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = TextCellValue(campaign.priority);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = DoubleCellValue(campaign.remainingBudget);
        campaignSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = DoubleCellValue(campaign.spentPercentage);
      }

      // Create Lead Generation sheet
      print('Adding lead generation data...');
      var leadSheet = excel['Lead_Generation'];

      // Add Lead Generation headers
      var leadHeaders = ['Day', 'Leads Generated', 'Color (Hex)'];

      for (int i = 0; i < leadHeaders.length; i++) {
        leadSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(leadHeaders[i]);
      }

      // Add Lead Generation data
      for (int i = 0; i < controller.leadGenerationData.length; i++) {
        var data = controller.leadGenerationData[i];
        var rowIndex = i + 1;

        leadSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(data.category);
        leadSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = DoubleCellValue(data.value);
        leadSheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: 2, rowIndex: rowIndex))
                .value =
            TextCellValue(
                '#${data.color.value.toRadixString(16).padLeft(8, '0').substring(2)}');
      }

      // Save Excel file
      print('Saving Excel file...');
      var fileBytes = excel.save();
      if (fileBytes == null || fileBytes.isEmpty) {
        throw Exception('Failed to generate Excel file bytes');
      }

      print(
          'Excel file generated successfully, size: ${fileBytes.length} bytes');

      final timestamp = _dateFormat.format(DateTime.now());
      final filename = 'SYAI_Marketing_Dashboard_Data_$timestamp.xlsx';

      print('Attempting to download: $filename');
      _downloadFile(
        filename,
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        bytes: Uint8List.fromList(fileBytes),
      );
      print('XLSX export completed successfully');
    } catch (e) {
      throw Exception('Failed to export XLSX: $e');
    }
  }

  /// Export dashboard data as PDF with Arabic support
  static Future<void> exportAsPDF() async {
    try {
      // Get controller with error handling
      late DashboardController controller;
      try {
        controller = Get.find<DashboardController>();
      } catch (e) {
        throw Exception(
            'Dashboard controller not found. Please make sure the dashboard is loaded first.');
      }

      if (controller.marketingKpis.isEmpty &&
          controller.activeCampaigns.isEmpty &&
          controller.leadGenerationData.isEmpty) {
        throw Exception('No data available for export');
      }
      final pdf = pw.Document();

      // Create custom theme with text direction support
      // Note: For Arabic text in PDF, consider using a font that supports Arabic
      // For now, we'll use English-only headers to avoid font issues
      final theme = pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      );

      pdf.addPage(
        pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          textDirection:
              pw.TextDirection.ltr, // Can be changed to rtl for Arabic
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'SYAI Marketing Dashboard Report',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textDirection: pw.TextDirection.ltr,
                    ),
                    pw.Text(
                      DateFormat('MMM dd, yyyy').format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 12),
                      textDirection: pw.TextDirection.ltr,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // KPI Section
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Key Performance Indicators',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),

              pw.SizedBox(height: 10),

              // KPI Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('KPI',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Value',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Trend',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                    ],
                  ),
                  // Data rows
                  ...controller.marketingKpis.map((kpi) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(kpi.title,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(kpi.value,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(kpi.subtitle,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(kpi.trend ?? 'N/A',
                                textDirection: pw.TextDirection.ltr),
                          ),
                        ],
                      )),
                ],
              ),

              pw.SizedBox(height: 30),

              // Campaigns Section
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Marketing Campaigns',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),

              pw.SizedBox(height: 10),

              // Campaigns Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Campaign',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Channel',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Status',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Budget',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('ROI',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                    ],
                  ),
                  // Data rows
                  ...controller.activeCampaigns.map((campaign) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(campaign.name,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(campaign.channel,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(campaign.status,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                '\$${campaign.budget.toStringAsFixed(0)}',
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                '${campaign.roi.toStringAsFixed(1)}x',
                                textDirection: pw.TextDirection.ltr),
                          ),
                        ],
                      )),
                ],
              ),

              pw.SizedBox(height: 30),

              // Lead Generation Section
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Lead Generation Data',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),

              pw.SizedBox(height: 10),

              // Lead Generation Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Day',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Leads Generated',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textDirection: pw.TextDirection.ltr),
                      ),
                    ],
                  ),
                  // Data rows
                  ...controller.leadGenerationData.map((data) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(data.category,
                                textDirection: pw.TextDirection.ltr),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(data.value.toString(),
                                textDirection: pw.TextDirection.ltr),
                          ),
                        ],
                      )),
                ],
              ),

              pw.SizedBox(height: 30),

              // Footer
              pw.Footer(
                title: pw.Text(
                  'Generated by SYAI Marketing Dashboard - ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 10),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF
      final Uint8List pdfBytes = await pdf.save();
      final timestamp = _dateFormat.format(DateTime.now());
      final filename = 'syai_dashboard_report_$timestamp.pdf';

      _downloadFile(
        filename,
        'application/pdf',
        bytes: pdfBytes,
      );
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  /// Export dashboard data as JSON
  static Future<void> exportAsJSON() async {
    try {
      // Get controller with error handling
      late DashboardController controller;
      try {
        controller = Get.find<DashboardController>();
      } catch (e) {
        throw Exception(
            'Dashboard controller not found. Please make sure the dashboard is loaded first.');
      }

      if (controller.marketingKpis.isEmpty &&
          controller.activeCampaigns.isEmpty &&
          controller.leadGenerationData.isEmpty) {
        throw Exception('No data available for export');
      }

      // Create comprehensive JSON structure
      final Map<String, dynamic> exportData = {
        'export_info': {
          'generated_at': DateTime.now().toIso8601String(),
          'version': '1.0.0',
          'source': 'SYAI Marketing Dashboard',
          'time_period': controller.selectedTimePeriod.value,
        },
        'kpis': controller.marketingKpis
            .map((kpi) => {
                  'title': kpi.title,
                  'value': kpi.value,
                  'subtitle': kpi.subtitle,
                  'trend': kpi.trend,
                  'is_positive': kpi.isPositive,
                  'icon_code': kpi.icon.codePoint,
                  'color_hex':
                      '#${kpi.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                })
            .toList(),
        'campaigns': controller.activeCampaigns
            .map((campaign) => {
                  'name': campaign.name,
                  'channel': campaign.channel,
                  'status': campaign.status,
                  'budget': campaign.budget,
                  'spent': campaign.spent,
                  'roi': campaign.roi,
                  'priority': campaign.priority,
                  'remaining_budget': campaign.remainingBudget,
                  'spent_percentage': campaign.spentPercentage,
                })
            .toList(),
        'lead_generation_data': controller.leadGenerationData
            .map((data) => {
                  'category': data.category,
                  'value': data.value,
                  'color_hex':
                      '#${data.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                })
            .toList(),
        'summary': {
          'total_kpis': controller.marketingKpis.length,
          'total_campaigns': controller.activeCampaigns.length,
          'active_campaigns': controller.activeCampaigns
              .where((c) => c.status == 'Active')
              .length,
          'total_budget':
              controller.activeCampaigns.fold(0.0, (sum, c) => sum + c.budget),
          'total_spent':
              controller.activeCampaigns.fold(0.0, (sum, c) => sum + c.spent),
          'average_roi': controller.activeCampaigns.isNotEmpty
              ? controller.activeCampaigns.fold(0.0, (sum, c) => sum + c.roi) /
                  controller.activeCampaigns.length
              : 0.0,
        },
      };

      // Convert to formatted JSON string
      final String jsonString =
          const JsonEncoder.withIndent('  ').convert(exportData);

      // Create and download file
      final timestamp = _dateFormat.format(DateTime.now());
      final filename = 'syai_dashboard_data_$timestamp.json';

      _downloadFile(filename, 'application/json', content: jsonString);
    } catch (e) {
      throw Exception('Failed to export JSON: $e');
    }
  }

  /// Download file in web browser
  static void _downloadFile(String filename, String mimeType,
      {String? content, Uint8List? bytes}) {
    print('_downloadFile called with filename: $filename, mimeType: $mimeType');
    try {
      if (bytes == null && content == null) {
        throw Exception('Either content or bytes must be provided');
      }

      print('Creating blob...');
      final blob = bytes != null
          ? html.Blob([bytes], mimeType)
          : html.Blob([content!], mimeType);
      print('Blob created successfully');

      print('Creating download URL...');
      final url = html.Url.createObjectUrlFromBlob(blob);
      print('URL created: $url');

      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = filename;

      print('Triggering download...');
      // Trigger download
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      print('Download triggered successfully');

      // Clean up
      html.Url.revokeObjectUrl(url);
      print('URL cleaned up');
    } catch (e) {
      print('Download failed: $e');
      throw Exception('Failed to download file: $e');
    }
  }
}
