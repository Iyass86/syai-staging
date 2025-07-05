import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ar_SA': arSA,
      };

  // English translations
  static const Map<String, String> enUS = {
    // App General
    'app_title': 'SYAI Dashboard',
    'app_subtitle': 'Marketing Analytics Hub',
    'welcome': 'Welcome',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'cancel': 'Cancel',
    'close': 'Close',
    'done': 'Done',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'confirm': 'Confirm',
    'yes': 'Yes',
    'no': 'No',
    'retry': 'Retry',
    'refresh': 'Refresh',

    // Navigation
    'main_navigation': 'Main Navigation',
    'quick_actions': 'Quick Actions',
    'dashboard': 'Dashboard',
    'performance_overview': 'Performance overview',
    'social_media': 'Social Media',
    'social_campaigns': 'Social campaigns',

    // Dashboard
    'marketing_dashboard': 'Marketing Dashboard',
    'welcome_marketing_hub': 'Welcome to SYAI Marketing Hub',
    'marketing_hub_description':
        'Your comprehensive platform for managing marketing campaigns, analyzing performance metrics, and driving business growth with AI-powered insights.',
    'refresh_data': 'Refresh Data',
    'export_data': 'Export Data',
    'contact_support': 'Contact Support',
    'dashboard_data_updated': 'Dashboard data is being updated...',
    'refreshing': 'Refreshing',

    // KPIs
    'total_leads': 'Total Leads',
    'this_month': 'This Month',
    'conversion_rate': 'Conversion Rate',
    'avg_monthly': 'Avg Monthly',
    'cost_per_lead': 'Cost per Lead',
    'current_average': 'Current Average',
    'active_campaigns': 'Active Campaigns',
    'currently_running': 'Currently Running',
    'ad_spend': 'Ad Spend',
    'email_open_rate': 'Email Open Rate',
    'last_30_days': 'Last 30 Days',
    'social_reach': 'Social Reach',
    'total_followers': 'Total Followers',
    'website_traffic': 'Website Traffic',
    'monthly_visitors': 'Monthly Visitors',
    'roi': 'ROI',
    'return_on_investment': 'Return on Investment',
    'lead_quality_score': 'Lead Quality Score',
    'average_rating': 'Average Rating',
    'customer_acquisition': 'Customer Acquisition',
    'new_customers': 'New Customers',
    'revenue_impact': 'Revenue Impact',
    'generated_revenue': 'Generated Revenue',

    // Time Periods
    'last_7_days': 'Last 7 Days',
    'last_30_days_period': 'Last 30 Days',
    'last_3_months': 'Last 3 Months',
    'last_year': 'Last Year',
    'time_period': 'Time Period',
    'select_time_period': 'Select Time Period',

    // Export
    'export_title': 'Export Data',
    'choose_export_format': 'Choose your preferred export format',
    'export_csv': 'Export as CSV',
    'export_csv_desc': 'Spreadsheet format for analysis',
    'export_pdf': 'Export as PDF',
    'export_pdf_desc': 'Print-ready report format',
    'export_json': 'Export as JSON',
    'export_json_desc': 'Raw data for developers',
    'generating_csv': 'Generating CSV export...',
    'generating_pdf': 'Generating PDF report...',
    'generating_json': 'Generating JSON export...',
    'export_successful': 'Export Successful',
    'export_failed': 'Export Failed',
    'csv_downloaded': 'CSV file has been downloaded successfully',
    'pdf_downloaded': 'PDF report has been downloaded successfully',
    'json_downloaded': 'JSON data has been downloaded successfully',
    'export_csv_failed': 'Failed to export CSV',
    'export_pdf_failed': 'Failed to export PDF',
    'export_json_failed': 'Failed to export JSON',
    'please_wait': 'Please wait...',

    // Theme
    'theme_settings': 'Theme Settings',
    'choose_theme_mode': 'Choose your preferred theme mode',
    'light_theme': 'Light Theme',
    'light_theme_desc': 'Clean and bright interface',
    'dark_theme': 'Dark Theme',
    'dark_theme_desc': 'Easy on the eyes',
    'system_theme': 'System Theme',
    'system_theme_desc': 'Follow device settings',
    'settings': 'Settings',
    'theme': 'Theme',

    // Contact
    'contact_title': 'Contact Support',
    'contact_desc': 'Get in touch with our marketing team',
    'email': 'Email',
    'phone': 'Phone',
    'website': 'Website',
    'slack': 'Slack',

    // Campaign Statuses
    'active': 'Active',
    'paused': 'Paused',
    'scheduled': 'Scheduled',
    'completed': 'Completed',
    'draft': 'Draft',

    // Campaign Priorities
    'high': 'High',
    'medium': 'Medium',
    'low': 'Low',

    // Campaign Channels
    'social_media_channel': 'Social Media',
    'email_marketing': 'Email Marketing',
    'google_ads': 'Google Ads',
    'influencer': 'Influencer',
    'blog_seo': 'Blog & SEO',
    'facebook_ads': 'Facebook Ads',
    'app_store': 'App Store',
    'linkedin': 'LinkedIn',

    // User Info
    'marketing_team': 'Marketing Team',
    'app_version': 'SYAI v1.0.0',

    // Days of Week
    'monday': 'Mon',
    'tuesday': 'Tue',
    'wednesday': 'Wed',
    'thursday': 'Thu',
    'friday': 'Fri',
    'saturday': 'Sat',
    'sunday': 'Sun',

    // Language Selection
    'language': 'Language',
    'select_language': 'Select Language',
    'english': 'English',
    'arabic': 'العربية',

    // Campaign Names
    'summer_sale_2025': 'Summer Sale 2025',
    'product_launch_campaign': 'Product Launch Campaign',
    'brand_awareness_drive': 'Brand Awareness Drive',
    'holiday_promotion': 'Holiday Promotion',
    'content_marketing_push': 'Content Marketing Push',
    'retargeting_campaign': 'Retargeting Campaign',
    'mobile_app_promotion': 'Mobile App Promotion',
    'webinar_series': 'Webinar Series',

    // Contact Information
    'contact_marketing_team': 'Contact Marketing Team',
    'marketing_email': 'marketing@syai.com',
    'marketing_phone': '+1 (555) 123-4567',
    'marketing_website': 'www.syai.com/marketing',
    'marketing_slack': '#marketing-team',

    // Chart data
    'lead_generation_chart': 'Lead Generation Chart',
    'campaign_performance': 'Campaign Performance',
    'kpi_overview': 'KPI Overview',

    // Notifications
    'failed_to_refresh': 'Failed to refresh data',

    // Table Headers
    'kpi_metric': 'KPI Metric',
    'current_value': 'Current Value',
    'description': 'Description',
    'trend': 'Trend',
    'monthly_change': 'Monthly Change',
    'status': 'Status',

    // Dashboard Content
    'marketing_trends_performance': 'Marketing Trends & Performance',
    'weekly_lead_generation_trends':
        'Weekly lead generation and conversion trends',
    'trend_analysis': 'Trend Analysis',
    'lead_generation': 'Lead Generation',
    'daily_leads_generated': 'Daily leads generated this week',
    'roi_distribution_by_channel': 'ROI distribution by channel',
    'key_insights': 'Key Insights',
    'best_performance_day': 'Best Performance Day',
    'daily_average': 'Daily Average',
    'trend_direction': 'Trend Direction',
    'strong_growth': 'Strong Growth',
    'steady_progress': 'Steady Progress',
    'marketing_performance_overview': 'Marketing Performance Overview',
    'kpi_for_marketing_operations':
        'Key Performance Indicators for Marketing Operations',
    'performance_meeting': 'Performance Meeting',

    // KPI Status
    'improving': 'Improving',
    'declining': 'Declining',
    'stable': 'Stable',

    // Campaign Table Headers
    'campaign_name': 'Campaign Name',
    'channel': 'Channel',
    'budget': 'Budget',
    'spent': 'Spent',
    'no_campaigns_available': 'No campaigns available',

    // Channel Names
    'channel_social_media': 'Social Media',
    'channel_email_marketing': 'Email Marketing',
    'channel_google_ads': 'Google Ads',
    'channel_facebook_ads': 'Facebook Ads',
    'channel_linkedin': 'LinkedIn',
    'channel_influencer': 'Influencer',
    'channel_app_store': 'App Store',
    'channel_other': 'Other',

    // Theme and UI
    'toggle_theme': 'Toggle Theme',
    'choose_preferred_language': 'Choose your preferred language',
    'language_changed': 'Language changed to',

    // Chat/Messages
    'failed_to_load_image': 'Failed to load image',
    'image_shared': 'Image shared',

    // Authentication & Forms
    'welcome_to_oauth_chat': 'Welcome to SyAi',
    'sign_in_subtitle': 'Sign in to access your AI-powered marketing dashboard',
    'password': 'Password',
    'login_with_email': 'Login with Email',
    'create_account': 'Create an Account',
    'continue_as_guest': 'Continue as Guest',
    'or': 'or',
    'guest_mode_notice':
        'Guest mode provides limited access. Create an account for full features.',
    'add_ads_managers': 'Add Ads Managers',
    'already_have_account': 'Already have an account? Login',
    'full_name': 'Full Name',
    'confirm_password': 'Confirm Password',
    'client_id': 'Client ID',
    'client_secret': 'Client Secret',
    'redirect_uri': 'Redirect URI',
    'url': 'URL',
    'logout': 'Logout',
    'logout_confirmation': 'Confirm Logout',
    'logout_confirmation_message':
        'Are you sure you want to logout? You will need to sign in again to access your account.',

    // Pages & Navigation
    'page_not_found': 'Page Not Found',
    'page_not_found_message': '404 - Page Not Found',
    'go_to_login': 'Go to Login',
    'syai_chat': 'SyAi Chat',
    'unknown_user': 'Unknown User',
    'refresh_messages': 'Refresh Messages',
    'ad_accounts': 'Ad Accounts',
    'no_address': 'No address',

    // Social Media
    'choose_platform': 'Choose Platform',
    'select_platform_description':
        'Select a social media platform to manage your ads',
    'social_media_platforms': 'Social Media Platforms',
    'snapchat_description': 'Manage your Snapchat ads and campaigns',
    'facebook_description': 'Manage your Facebook ads and campaigns',
    'instagram_description': 'Manage your Instagram ads and campaigns',
    'tiktok_description': 'Manage your TikTok ads and campaigns',
    'available': 'Available',
    'platform_selected': 'Platform Selected',
    'connecting_to': 'Connecting to',
    'coming_soon': 'Coming Soon',
    'manage_ads': 'Manage Ads',
    'social_media_dashboard': 'Social Media Dashboard',
    'manage_social_campaigns':
        'Manage your social media campaigns and track performance',
    'engagement_rate': 'Engagement Rate',
    'platform_performance': 'Platform Performance',
    'engagement_distribution': 'Engagement Distribution by Platform',
    'recent_social_campaigns': 'Recent Social Campaigns',
    'latest_campaign_performance': 'Latest campaign performance and metrics',
    'new_campaign': 'New Campaign',
    'reach': 'Reach',
    'engagement': 'Engagement',

    // Snap Auth Page
    'connect_ads_account': 'Connect Ads Account',
    'connect_snap_account': 'Connect Snapchat Account',
    'setup_advertising_credentials':
        'Set up your advertising account credentials',
    'enter_client_id': 'Enter your client ID',
    'enter_client_secret': 'Enter your client secret',
    'enter_redirect_url': 'Enter redirect URL',
    'enter_redirect_uri_code': 'Enter redirect URI with code',
    'is_required': 'is required',
    'connect_account': 'Connect Account',
    'sign_in': 'Sign In',
    'get_code_oauth': 'Get Code via OAuth',
  };

  // Arabic translations
  static const Map<String, String> arSA = {
    // App General
    'app_title': 'لوحة تحكم SYAI',
    'app_subtitle': 'مركز تحليلات التسويق',
    'welcome': 'مرحباً',
    'loading': 'جارٍ التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'cancel': 'إلغاء',
    'close': 'إغلاق',
    'done': 'تم',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'confirm': 'تأكيد',
    'yes': 'نعم',
    'no': 'لا',
    'retry': 'إعادة المحاولة',
    'refresh': 'تحديث',

    // Navigation
    'main_navigation': 'التنقل الرئيسي',
    'quick_actions': 'الإجراءات السريعة',
    'dashboard': 'لوحة التحكم',
    'performance_overview': 'نظرة عامة على الأداء',
    'social_media': 'وسائل التواصل الاجتماعي',
    'social_campaigns': 'الحملات الاجتماعية',

    // Dashboard
    'marketing_dashboard': 'لوحة تحكم التسويق',
    'welcome_marketing_hub': 'مرحباً بك في مركز التسويق SYAI',
    'marketing_hub_description':
        'منصتك الشاملة لإدارة الحملات التسويقية وتحليل مقاييس الأداء ودفع نمو الأعمال بواسطة رؤى مدعومة بالذكاء الاصطناعي.',
    'refresh_data': 'تحديث البيانات',
    'export_data': 'تصدير البيانات',
    'contact_support': 'اتصل بالدعم',
    'dashboard_data_updated': 'جارٍ تحديث بيانات لوحة التحكم...',
    'refreshing': 'جارٍ التحديث',

    // KPIs
    'total_leads': 'إجمالي العملاء المحتملين',
    'this_month': 'هذا الشهر',
    'conversion_rate': 'معدل التحويل',
    'avg_monthly': 'المتوسط الشهري',
    'cost_per_lead': 'التكلفة لكل عميل محتمل',
    'current_average': 'المتوسط الحالي',
    'active_campaigns': 'الحملات النشطة',
    'currently_running': 'قيد التشغيل حالياً',
    'ad_spend': 'إنفاق الإعلانات',
    'email_open_rate': 'معدل فتح البريد الإلكتروني',
    'last_30_days': 'آخر 30 يوماً',
    'social_reach': 'الوصول الاجتماعي',
    'total_followers': 'إجمالي المتابعين',
    'website_traffic': 'زيارات الموقع',
    'monthly_visitors': 'الزوار الشهريين',
    'roi': 'عائد الاستثمار',
    'return_on_investment': 'عائد الاستثمار',
    'lead_quality_score': 'نقاط جودة العملاء المحتملين',
    'average_rating': 'التقييم المتوسط',
    'customer_acquisition': 'اكتساب العملاء',
    'new_customers': 'عملاء جدد',
    'revenue_impact': 'تأثير الإيرادات',
    'generated_revenue': 'الإيرادات المُولدة',

    // Time Periods
    'last_7_days': 'آخر 7 أيام',
    'last_30_days_period': 'آخر 30 يوماً',
    'last_3_months': 'آخر 3 شهور',
    'last_year': 'العام الماضي',
    'time_period': 'الفترة الزمنية',
    'select_time_period': 'اختر الفترة الزمنية',

    // Export
    'export_title': 'تصدير البيانات',
    'choose_export_format': 'اختر تنسيق التصدير المفضل لديك',
    'export_csv': 'تصدير كـ CSV',
    'export_csv_desc': 'تنسيق جدول بيانات للتحليل',
    'export_pdf': 'تصدير كـ PDF',
    'export_pdf_desc': 'تنسيق تقرير جاهز للطباعة',
    'export_json': 'تصدير كـ JSON',
    'export_json_desc': 'بيانات خام للمطورين',
    'generating_csv': 'جارٍ إنشاء تصدير CSV...',
    'generating_pdf': 'جارٍ إنشاء تقرير PDF...',
    'generating_json': 'جارٍ إنشاء تصدير JSON...',
    'export_successful': 'تم التصدير بنجاح',
    'export_failed': 'فشل التصدير',
    'csv_downloaded': 'تم تنزيل ملف CSV بنجاح',
    'pdf_downloaded': 'تم تنزيل تقرير PDF بنجاح',
    'json_downloaded': 'تم تنزيل بيانات JSON بنجاح',
    'export_csv_failed': 'فشل في تصدير CSV',
    'export_pdf_failed': 'فشل في تصدير PDF',
    'export_json_failed': 'فشل في تصدير JSON',
    'please_wait': 'يرجى الانتظار...',

    // Theme
    'theme_settings': 'إعدادات المظهر',
    'choose_theme_mode': 'اختر نمط المظهر المفضل لديك',
    'light_theme': 'المظهر الفاتح',
    'light_theme_desc': 'واجهة نظيفة ومشرقة',
    'dark_theme': 'المظهر الداكن',
    'dark_theme_desc': 'مريح للعينين',
    'system_theme': 'مظهر النظام',
    'system_theme_desc': 'اتبع إعدادات الجهاز',
    'settings': 'الإعدادات',
    'theme': 'المظهر',

    // Contact
    'contact_title': 'اتصل بالدعم',
    'contact_desc': 'تواصل مع فريق التسويق لدينا',
    'email': 'البريد الإلكتروني',
    'phone': 'الهاتف',
    'website': 'الموقع الإلكتروني',
    'slack': 'سلاك',

    // Campaign Statuses
    'active': 'نشط',
    'paused': 'متوقف',
    'scheduled': 'مجدول',
    'completed': 'مكتمل',
    'draft': 'مسودة',

    // Campaign Priorities
    'high': 'عالي',
    'medium': 'متوسط',
    'low': 'منخفض',

    // Campaign Channels
    'social_media_channel': 'وسائل التواصل الاجتماعي',
    'email_marketing': 'التسويق عبر البريد الإلكتروني',
    'google_ads': 'إعلانات جوجل',
    'influencer': 'المؤثرين',
    'blog_seo': 'المدونة وتحسين محركات البحث',
    'facebook_ads': 'إعلانات فيسبوك',
    'app_store': 'متجر التطبيقات',
    'linkedin': 'لينكد إن',

    // User Info
    'marketing_team': 'فريق التسويق',
    'app_version': 'SYAI الإصدار 1.0.0',

    // Days of Week
    'monday': 'الاثنين',
    'tuesday': 'الثلاثاء',
    'wednesday': 'الأربعاء',
    'thursday': 'الخميس',
    'friday': 'الجمعة',
    'saturday': 'السبت',
    'sunday': 'الأحد',

    // Language Selection
    'language': 'اللغة',
    'select_language': 'اختر اللغة',
    'english': 'English',
    'arabic': 'العربية',

    // Campaign Names
    'summer_sale_2025': 'تخفيضات الصيف 2025',
    'product_launch_campaign': 'حملة إطلاق المنتج',
    'brand_awareness_drive': 'حملة الوعي بالعلامة التجارية',
    'holiday_promotion': 'عروض العطلة',
    'content_marketing_push': 'دفعة التسويق بالمحتوى',
    'retargeting_campaign': 'حملة إعادة الاستهداف',
    'mobile_app_promotion': 'ترويج تطبيق الهاتف المحمول',
    'webinar_series': 'سلسلة الندوات الإلكترونية',

    // Contact Information
    'contact_marketing_team': 'اتصل بفريق التسويق',
    'marketing_email': 'marketing@syai.com',
    'marketing_phone': '+1 (555) 123-4567',
    'marketing_website': 'www.syai.com/marketing',
    'marketing_slack': '#marketing-team',

    // Chart data
    'lead_generation_chart': 'مخطط توليد العملاء المحتملين',
    'campaign_performance': 'أداء الحملة',
    'kpi_overview': 'نظرة عامة على مؤشرات الأداء الرئيسية',

    // Notifications
    'failed_to_refresh': 'فشل في تحديث البيانات',

    // Table Headers
    'kpi_metric': 'مقياس الأداء الرئيسي',
    'current_value': 'القيمة الحالية',
    'description': 'الوصف',
    'trend': 'الاتجاه',
    'monthly_change': 'التغيير الشهري',
    'status': 'الحالة',

    // Dashboard Content
    'marketing_trends_performance': 'اتجاهات وأداء التسويق',
    'weekly_lead_generation_trends':
        'اتجاهات توليد العملاء المحتملين والتحويل الأسبوعي',
    'trend_analysis': 'تحليل الاتجاه',
    'lead_generation': 'توليد العملاء المحتملين',
    'daily_leads_generated': 'العملاء المحتملون المتولدون يومياً هذا الأسبوع',
    'roi_distribution_by_channel': 'توزيع العائد على الاستثمار حسب القناة',
    'key_insights': 'الرؤى الرئيسية',
    'best_performance_day': 'أفضل يوم أداء',
    'daily_average': 'المعدل اليومي',
    'trend_direction': 'اتجاه النمو',
    'strong_growth': 'نمو قوي',
    'steady_progress': 'تقدم مستمر',
    'marketing_performance_overview': 'نظرة عامة على أداء التسويق',
    'kpi_for_marketing_operations': 'مؤشرات الأداء الرئيسية لعمليات التسويق',
    'performance_meeting': 'اجتماع الأداء',

    // KPI Status
    'improving': 'تحسن',
    'declining': 'تراجع',
    'stable': 'مستقر',

    // Campaign Table Headers
    'campaign_name': 'اسم الحملة',
    'channel': 'القناة',
    'budget': 'الميزانية',
    'spent': 'المنفق',
    'no_campaigns_available': 'لا توجد حملات متاحة',

    // Channel Names
    'channel_social_media': 'وسائل التواصل الاجتماعي',
    'channel_email_marketing': 'التسويق عبر البريد الإلكتروني',
    'channel_google_ads': 'إعلانات جوجل',
    'channel_facebook_ads': 'إعلانات فيسبوك',
    'channel_linkedin': 'لينكد إن',
    'channel_influencer': 'المؤثرين',
    'channel_app_store': 'متجر التطبيقات',
    'channel_other': 'أخرى',

    // Theme and UI
    'toggle_theme': 'تغيير السمة',
    'choose_preferred_language': 'اختر لغتك المفضلة',
    'language_changed': 'تم تغيير اللغة إلى',

    // Chat/Messages
    'failed_to_load_image': 'فشل في تحميل الصورة',
    'image_shared': 'تم مشاركة الصورة',

    // Authentication & Forms
    'welcome_to_oauth_chat': 'مرحباً بك في SyAi',
    'sign_in_subtitle':
        'قم بتسجيل الدخول للوصول إلى لوحة التحكم التسويقية المدعومة بالذكاء الاصطناعي',
    'password': 'كلمة المرور',
    'login_with_email': 'تسجيل الدخول بالبريد الإلكتروني',
    'create_account': 'إنشاء حساب',
    'continue_as_guest': 'المتابعة كضيف',
    'or': 'أو',
    'guest_mode_notice':
        'وضع الضيف يوفر وصولاً محدوداً. أنشئ حساباً للحصول على جميع الميزات.',
    'add_ads_managers': 'إضافة مدراء الإعلانات',
    'already_have_account': 'هل لديك حساب بالفعل؟ تسجيل الدخول',
    'full_name': 'الاسم الكامل',
    'confirm_password': 'تأكيد كلمة المرور',
    'client_id': 'معرف العميل',
    'client_secret': 'سر العميل',
    'redirect_uri': 'رابط إعادة التوجيه',
    'url': 'الرابط',
    'logout': 'تسجيل خروج',
    'logout_confirmation': 'تأكيد تسجيل الخروج',
    'logout_confirmation_message':
        'هل أنت متأكد من تسجيل الخروج؟ ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك.',

    // Pages & Navigation
    'page_not_found': 'الصفحة غير موجودة',
    'page_not_found_message': '404 - الصفحة غير موجودة',
    'go_to_login': 'الذهاب لتسجيل الدخول',
    'syai_chat': 'محادثة SyAi',
    'unknown_user': 'مستخدم غير معروف',
    'refresh_messages': 'تحديث الرسائل',
    'ad_accounts': 'حسابات الإعلانات',
    'no_address': 'لا يوجد عنوان',

    // Social Media
    'choose_platform': 'اختر المنصة',
    'select_platform_description':
        'اختر منصة وسائل التواصل الاجتماعي لإدارة إعلاناتك',
    'social_media_platforms': 'منصات وسائل التواصل الاجتماعي',
    'snapchat_description': 'إدارة إعلانات وحملات سناب شات',
    'facebook_description': 'إدارة إعلانات وحملات فيسبوك',
    'instagram_description': 'إدارة إعلانات وحملات إنستغرام',
    'tiktok_description': 'إدارة إعلانات وحملات تيك توك',
    'available': 'متاح',
    'platform_selected': 'تم اختيار المنصة',
    'connecting_to': 'الاتصال بـ',
    'coming_soon': 'قريباً',
    'manage_ads': 'إدارة الإعلانات',
    'social_media_dashboard': 'لوحة تحكم وسائل التواصل الاجتماعي',
    'manage_social_campaigns':
        'إدارة حملات وسائل التواصل الاجتماعي وتتبع الأداء',
    'engagement_rate': 'معدل التفاعل',
    'platform_performance': 'أداء المنصات',
    'engagement_distribution': 'توزيع التفاعل حسب المنصة',
    'recent_social_campaigns': 'الحملات الاجتماعية الحديثة',
    'latest_campaign_performance': 'أحدث أداء الحملات والمقاييس',
    'new_campaign': 'حملة جديدة',
    'reach': 'الوصول',
    'engagement': 'التفاعل',

    // Snap Auth Page
    'connect_ads_account': 'ربط حساب الإعلانات',
    'connect_snap_account': 'ربط حساب سناب شات',
    'setup_advertising_credentials': 'إعداد بيانات اعتماد حساب الإعلانات',
    'enter_client_id': 'أدخل معرف العميل',
    'enter_client_secret': 'أدخل سر العميل',
    'enter_redirect_url': 'أدخل رابط إعادة التوجيه',
    'enter_redirect_uri_code': 'أدخل رابط إعادة التوجيه مع الكود',
    'is_required': 'مطلوب',
    'connect_account': 'ربط الحساب',
    'sign_in': 'تسجيل الدخول',
    'get_code_oauth': 'الحصول على الكود عبر OAuth',
  };
}
