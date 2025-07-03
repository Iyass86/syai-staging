# SYAI Dashboard Export Features Guide

## Overview

The SYAI Marketing Dashboard now supports advanced export functionality with XLSX and PDF formats, including Arabic language support for international users.

## Available Export Formats

### 1. XLSX (Excel) Export ✨ NEW

**File Format:** `.xlsx`  
**Features:**

- Multiple worksheets for organized data
- Separate sheets for KPIs, Campaigns, and Lead Generation data
- Proper data types (numbers, text, dates)
- Compatible with Microsoft Excel, Google Sheets, LibreOffice Calc
- Arabic text support for international markets

**Data Structure:**

```
📄 KPI_Data Sheet:
├── KPI Title
├── Value
├── Subtitle
├── Trend
└── Is Positive

📄 Campaigns Sheet:
├── Campaign Name
├── Channel
├── Status
├── Budget (numerical)
├── Spent (numerical)
├── ROI (numerical)
├── Priority
├── Remaining Budget (calculated)
└── Spent Percentage (calculated)

📄 Lead_Generation Sheet:
├── Day
├── Leads Generated (numerical)
└── Color (Hex)
```

### 2. PDF Export with Arabic Support 🌍

**File Format:** `.pdf`  
**Features:**

- Bilingual headers (English | Arabic)
- Professional layout with tables
- Proper text direction support
- Print-ready format
- Comprehensive data coverage

**Bilingual Headers:**

- "Key Performance Indicators | مؤشرات الأداء الرئيسية"
- "Marketing Campaigns | الحملات التسويقية"
- "Lead Generation Data | بيانات توليد العملاء المحتملين"

### 3. JSON Export (Existing)

**File Format:** `.json`  
**Features:**

- Complete data structure preservation
- API-friendly format
- Metadata included
- Color values and icon codes preserved

## How to Use Export Features

### Via Navigation Menu

1. Click the hamburger menu (☰) in the top navigation
2. Go to **"Export & Data"** section
3. Choose your desired export format:
   - **"Export as XLSX"** - Generate Excel spreadsheet
   - **"Export as PDF"** - Generate bilingual PDF report
   - **"Export as JSON"** - Generate JSON data file

### Export Process

1. Click on your chosen export option
2. A loading dialog will appear
3. File will automatically download to your browser's download folder
4. Success notification will confirm completion

## File Naming Convention

All exported files follow this naming pattern:

```
syai_dashboard_[type]_YYYY-MM-DD_HH-mm-ss.[extension]

Examples:
- syai_dashboard_export_2025-06-28_14-30-45.xlsx
- syai_dashboard_report_2025-06-28_14-30-45.pdf
- syai_dashboard_data_2025-06-28_14-30-45.json
```

## Data Accuracy

- All exports reflect the current dashboard state
- Zero default values are maintained when no URL parameters are provided
- URL parameter overrides are included in exports
- Real-time data synchronization

## Arabic Language Support

The PDF export includes Arabic translations for:

- Section headers and titles
- Table column headers
- Footer information
- Mixed language display (English | Arabic)

## Technical Details

### Dependencies Added

```yaml
excel: ^4.0.6 # For XLSX generation
```

### Browser Compatibility

- ✅ Chrome/Chromium
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ✅ Mobile browsers

### File Size Estimates

- **XLSX:** ~15-25KB (depending on data volume)
- **PDF:** ~50-100KB (including Arabic fonts)
- **JSON:** ~5-15KB (compact structure)

## Use Cases

### Business Reporting

- Weekly/monthly dashboard snapshots
- Executive summary generation
- Performance tracking documentation
- Multi-language team communication

### Data Analysis

- Import XLSX into analysis tools
- Historical data preservation
- Trend analysis preparation
- Integration with other systems

### Compliance & Auditing

- Formal report generation
- Data backup and archival
- Audit trail documentation
- Regulatory compliance

## Troubleshooting

### Common Issues

1. **Download doesn't start**: Check browser pop-up blockers
2. **File corruption**: Ensure stable internet connection
3. **Arabic text not displaying**: Use modern PDF viewers

### Browser Settings

- Enable downloads in browser settings
- Allow pop-ups for the dashboard domain
- Ensure sufficient storage space

## Future Enhancements

- [ ] Excel charts and graphs inclusion
- [ ] Custom date range filtering
- [ ] Scheduled automatic exports
- [ ] Email delivery integration
- [ ] Additional language support

## Support

For technical support or feature requests, contact the development team through the dashboard's built-in feedback system.

---

_Generated for SYAI Marketing Dashboard v2.0_  
_Last Updated: June 28, 2025_
