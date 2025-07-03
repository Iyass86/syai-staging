# Marketing Dashboard

## Overview

A comprehensive marketing dashboard built with Flutter for web that prominently displays key marketing KPIs as individual, easy-to-read cards. The dashboard provides an immediate, at-a-glance view of the most important marketing metrics.

## Features

### 📊 Prominent KPI Display

The dashboard features a responsive grid of large, visually appealing KPI cards, each showing:

- **Large numerical values** for immediate impact
- **Clear titles** and descriptive subtitles
- **Color-coded icons** for quick visual recognition
- **Trend indicators** showing performance changes
- **Interactive cards** that can be tapped for detailed views

### 🎯 Key Marketing KPIs

- **Total Leads**: 2,847 leads this month (+24.5% trend)
- **Conversion Rate**: 4.2% average monthly (+0.8% trend)
- **Cost per Lead**: $45.20 current average (-$2.10 improvement)
- **Active Campaigns**: 8 currently running (+2 new campaigns)
- **Ad Spend**: $89,420 this month (+8.7% increase)
- **Email Open Rate**: 28.4% last 30 days (+3.2% improvement)
- **Social Reach**: 124.5K total followers (+12.8K growth)
- **Website Traffic**: 45.2K monthly visitors (+18.3% growth)
- **ROI**: 4.8x return on investment (+0.3x improvement)
- **Lead Quality Score**: 8.5/10 average rating (+0.2 improvement)
- **Customer Acquisition**: 342 new customers (+28 this period)
- **Revenue Impact**: $234K generated revenue (+15.2% growth)

### 📱 Responsive Design

- **Desktop**: 4-column grid for maximum data visibility
- **Tablet**: 3-column grid with optimized spacing
- **Mobile**: 2-column or single-column layout for easy viewing
- **Dynamic sizing**: Cards automatically adjust to screen size

### ⚙️ Dashboard Features

- **Theme Support**: Light, dark, and system theme options
- **Time Period Selection**: View data for different time ranges
- **Responsive KPI Grid**: Automatically adjusts to screen size
- **Interactive Cards**: Tap any KPI card for detailed insights
- **Navigation**: Easy navigation between different sections
- **Contact Support**: Quick access to marketing team contact information
- **Real-time Updates**: Refresh button to update all KPI data

## Technology Stack

- **Flutter**: Cross-platform UI framework
- **GetX**: State management and navigation
- **Material Design 3**: Modern UI components with custom KPI cards
- **Responsive Grid**: Adaptive layout system for all screen sizes

## KPI Card Features

### Visual Design

- **Large, bold numbers**: Easy-to-read values at a glance
- **Color-coded themes**: Each metric has its own color scheme
- **Gradient backgrounds**: Subtle gradients for visual appeal
- **Material Design**: Cards with proper elevation and shadows

### Interactive Elements

- **Trend indicators**: Up/down arrows with percentage changes
- **Hover effects**: Visual feedback on interaction
- **Tap to expand**: Future functionality for detailed metric views
- **Icon representation**: Meaningful icons for each KPI type

### Data Presentation

- **Primary value**: Large, prominent display of main metric
- **Subtitle context**: Additional information below main value
- **Trend data**: Performance indicators with color coding
- **Time context**: Period information for each metric

## KPI Categories

### Lead Generation & Acquisition

- **Total Leads**: Overall lead volume with monthly trends
- **Lead Quality Score**: Rating system for lead qualification
- **Customer Acquisition**: New customers gained
- **Cost per Lead**: Efficiency metric for lead generation costs

### Campaign Performance

- **Active Campaigns**: Number of running marketing initiatives
- **Conversion Rate**: Effectiveness of marketing efforts
- **ROI**: Return on investment across all campaigns
- **Ad Spend**: Total advertising expenditure tracking

### Digital Marketing Metrics

- **Email Open Rate**: Email campaign performance indicator
- **Social Reach**: Social media audience size and growth
- **Website Traffic**: Visitor volume and engagement metrics

### Revenue & Impact

- **Revenue Impact**: Direct revenue attribution to marketing
- **Cost Efficiency**: Various cost-per-action metrics
- **Performance Trends**: Month-over-month growth indicators

## Usage

### Running the Dashboard

1. Ensure Flutter is installed and configured
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run -d chrome --web-port=3000` to start the dashboard
5. Open your browser to `http://localhost:3000`

### Navigation

- Use the menu button (☰) in the top-left to navigate between sections
- Access theme settings and other options via the settings menu (⋮) in the top-right
- Refresh data using the refresh button in the app bar

### Customization

The dashboard can be easily customized to include additional metrics or modify existing ones by updating:

- `DashboardController`: Add new data sources and metrics
- `MarketingCampaignsTable`: Modify campaign data display
- `DashboardCard`: Add new metric cards
- `DashboardChart`: Customize chart appearance and data

## Marketing-Specific Features

### Campaign Status Tracking

- **Active**: Campaigns currently running
- **Paused**: Temporarily stopped campaigns
- **Scheduled**: Future campaigns ready to launch
- **Completed**: Finished campaigns for reference

### Channel Performance

Monitor performance across various marketing channels:

- Social Media campaigns
- Email marketing initiatives
- Google Ads campaigns
- Influencer partnerships
- Content marketing and SEO
- Facebook advertising
- App store promotions
- LinkedIn campaigns

### ROI Analysis

- Real-time ROI calculations for each campaign
- Visual indicators for high-performing campaigns
- Budget vs. spending tracking with progress bars
- Cost-per-lead analysis

## Data Refresh

The dashboard automatically loads sample data and can be refreshed using the refresh button. In a production environment, this would connect to your marketing analytics APIs and databases.

## Support

For technical support or questions about the marketing dashboard, contact the marketing team through the "Contact Us" option in the settings menu.

## Usage Instructions

### Viewing KPIs

1. **Main Grid**: All KPIs are displayed in a responsive grid layout
2. **Quick Scan**: Large numbers allow for immediate data comprehension
3. **Trend Analysis**: Green up arrows indicate positive trends, red down arrows show declines
4. **Context**: Subtitles provide time period and context for each metric

### Interaction

- **Tap any card**: Get a notification with the KPI name (future: detailed view)
- **Refresh data**: Use the refresh button in the app bar
- **Change themes**: Access theme options through the settings menu
- **Navigate**: Use the menu button for navigation between sections
