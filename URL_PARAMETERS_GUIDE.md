# Dashboard URL Parameters Guide

## Overview

The SYAI Dashboard now supports passing KPI data and other parameters via URL to dynamically display custom data on the dashboard.

## Supported URL Parameters

### Basic Usage

```
http://localhost:61363/dashboard?leads=5000&conversion_rate=6.8&ad_spend=125000
```

### Available Parameters

| Parameter         | Description            | Example                 | Display Format              |
| ----------------- | ---------------------- | ----------------------- | --------------------------- |
| `date`            | Date filter            | `date=2025-06-28`       | Shows as "Date: 2025-06-28" |
| `leads`           | Total leads count      | `leads=5000`            | Displays as "5.0K"          |
| `conversion_rate` | Conversion rate %      | `conversion_rate=6.8`   | Displays as "6.8%"          |
| `cost_per_lead`   | Cost per lead in USD   | `cost_per_lead=35.50`   | Displays as "$35.50"        |
| `campaigns`       | Active campaigns count | `campaigns=12`          | Displays as "12"            |
| `ad_spend`        | Ad spend in USD        | `ad_spend=125000`       | Displays as "$125.0K"       |
| `email_open_rate` | Email open rate %      | `email_open_rate=32.5`  | Displays as "32.5%"         |
| `social_reach`    | Social media reach     | `social_reach=250000`   | Displays as "250.0K"        |
| `website_traffic` | Website traffic        | `website_traffic=85000` | Displays as "85.0K"         |
| `roi`             | Return on investment   | `roi=5.2`               | Displays as "5.2x"          |
| `lead_quality`    | Lead quality score     | `lead_quality=8.9`      | Displays as "8.9/10"        |
| `new_customers`   | New customers          | `new_customers=450`     | Displays as "450"           |
| `revenue`         | Revenue impact         | `revenue=450000`        | Displays as "$450.0K"       |

### Example URLs

#### Basic KPI Update

```
http://localhost:61363/dashboard?leads=3500&conversion_rate=5.8&roi=4.2
```

#### Comprehensive Dashboard Update

```
http://localhost:61363/dashboard?date=2025-06-28&leads=7500&conversion_rate=8.2&cost_per_lead=28.75&campaigns=15&ad_spend=200000&email_open_rate=35.8&social_reach=380000&website_traffic=120000&roi=6.1&lead_quality=9.2&new_customers=650&revenue=750000
```

#### Date-Specific Report

```
http://localhost:61363/dashboard?date=2025-06-15&leads=4200&ad_spend=95000&roi=3.8
```

## Features

### 1. Dynamic KPI Display

- URL parameters override default KPI values
- Real-time updates when URL changes
- Automatic number formatting (K for thousands, M for millions)

### 2. URL Parameter Display

- Parameters are shown in a highlighted box at the top of the dashboard
- Easy to see which parameters are currently active
- Clear visual indication when URL parameters are being used

### 3. Persistent Navigation

- URL parameters work with both Overview and Social Media views
- Parameters persist when switching between dashboard views
- Navigation state is maintained

## Technical Implementation

### Controller Features

- Automatic URL parameter parsing in `DashboardController`
- Number formatting helper methods
- Real-time parameter detection and display
- Integration with existing KPI system

### UI Features

- Parameter display box in welcome section
- Responsive design that works on all screen sizes
- Clean visual design that matches dashboard theme
- Conditional display (only shows when parameters are present)

## Testing Examples

### Test with Sample Data

1. Navigate to: `http://localhost:61363/dashboard?leads=5000&conversion_rate=7.5&ad_spend=150000`
2. Verify the KPI cards show updated values
3. Check that the URL parameters box appears in the welcome section
4. Switch to Social Media view and verify parameters persist

### Test Number Formatting

1. Navigate to: `http://localhost:61363/dashboard?leads=1250000&ad_spend=2500000`
2. Verify leads shows as "1.3M" and ad spend shows as "$2.5M"

### Test Multiple Parameters

1. Use the comprehensive URL example above
2. Verify all KPI cards are updated with the new values
3. Check that the parameter display shows all active parameters

## Benefits

- **Dynamic Reporting**: Create custom dashboard views with specific KPI values
- **URL Sharing**: Share specific dashboard states with stakeholders
- **Testing**: Easy testing of dashboard with different data scenarios
- **Integration**: Simple API for external systems to pass data to dashboard
- **Real-time Updates**: Instant dashboard updates when URL parameters change
