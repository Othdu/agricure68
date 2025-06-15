import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Localization delegate
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('es', ''), // Spanish
    Locale('fr', ''), // French
    Locale('ar', ''), // Arabic
    Locale('zh', ''), // Chinese
  ];

  // Text strings
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get contactUs => _localizedValues[locale.languageCode]!['contactUs']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get accessibility => _localizedValues[locale.languageCode]!['accessibility']!;
  String get weatherOverview => _localizedValues[locale.languageCode]!['weatherOverview']!;
  String get sensorData => _localizedValues[locale.languageCode]!['sensorData']!;
  String get temperature => _localizedValues[locale.languageCode]!['temperature']!;
  String get humidity => _localizedValues[locale.languageCode]!['humidity']!;
  String get soilMoisture => _localizedValues[locale.languageCode]!['soilMoisture']!;
  String get wind => _localizedValues[locale.languageCode]!['wind']!;
  String get weatherCondition => _localizedValues[locale.languageCode]!['weatherCondition']!;
  String get lastUpdated => _localizedValues[locale.languageCode]!['lastUpdated']!;
  String get refresh => _localizedValues[locale.languageCode]!['refresh']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get optimal => _localizedValues[locale.languageCode]!['optimal']!;
  String get critical => _localizedValues[locale.languageCode]!['critical']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get good => _localizedValues[locale.languageCode]!['good']!;
  String get poor => _localizedValues[locale.languageCode]!['poor']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get customize => _localizedValues[locale.languageCode]!['customize']!;
  String get addWidget => _localizedValues[locale.languageCode]!['addWidget']!;
  String get removeWidget => _localizedValues[locale.languageCode]!['removeWidget']!;
  String get screenReader => _localizedValues[locale.languageCode]!['screenReader']!;
  String get highContrast => _localizedValues[locale.languageCode]!['highContrast']!;
  String get largeText => _localizedValues[locale.languageCode]!['largeText']!;
  String get reduceMotion => _localizedValues[locale.languageCode]!['reduceMotion']!;
  
  // New translations for hardcoded text
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcomeBack']!;
  String get farmStatus => _localizedValues[locale.languageCode]!['farmStatus']!;
  String get schedule => _localizedValues[locale.languageCode]!['schedule']!;
  String get market => _localizedValues[locale.languageCode]!['market']!;
  String get insights => _localizedValues[locale.languageCode]!['insights']!;
  String get sensorOverview => _localizedValues[locale.languageCode]!['sensorOverview']!;
  String get sensorDetails => _localizedValues[locale.languageCode]!['sensorDetails']!;
  String get marketPrices => _localizedValues[locale.languageCode]!['marketPrices']!;
  String get farmStats => _localizedValues[locale.languageCode]!['farmStats']!;
  String get quickTips => _localizedValues[locale.languageCode]!['quickTips']!;
  String get cropCalendar => _localizedValues[locale.languageCode]!['cropCalendar']!;
  String get noUpcomingActivities => _localizedValues[locale.languageCode]!['noUpcomingActivities']!;
  String get marketPricesNotAvailable => _localizedValues[locale.languageCode]!['marketPricesNotAvailable']!;
  String get farmStatsNotAvailable => _localizedValues[locale.languageCode]!['farmStatsNotAvailable']!;
  String get noTipsAvailable => _localizedValues[locale.languageCode]!['noTipsAvailable']!;
  String get totalCrops => _localizedValues[locale.languageCode]!['totalCrops']!;
  String get landArea => _localizedValues[locale.languageCode]!['landArea']!;
  String get waterUsage => _localizedValues[locale.languageCode]!['waterUsage']!;
  String get aboutAgriCure => _localizedValues[locale.languageCode]!['aboutAgriCure']!;
  String get appDescription => _localizedValues[locale.languageCode]!['appDescription']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get confirmLogout => _localizedValues[locale.languageCode]!['confirmLogout']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get privacyPolicy => _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get termsOfService => _localizedValues[locale.languageCode]!['termsOfService']!;
  String get customizeDashboard => _localizedValues[locale.languageCode]!['customizeDashboard']!;
  String get addWidgets => _localizedValues[locale.languageCode]!['addWidgets']!;
  String get dashboardCustomizationComingSoon => _localizedValues[locale.languageCode]!['dashboardCustomizationComingSoon']!;
  String get widgetSelectionComingSoon => _localizedValues[locale.languageCode]!['widgetSelectionComingSoon']!;
  String get enableScreenReaderSupport => _localizedValues[locale.languageCode]!['enableScreenReaderSupport']!;
  String get increaseContrastForBetterVisibility => _localizedValues[locale.languageCode]!['increaseContrastForBetterVisibility']!;
  String get increaseTextSizeForBetterReadability => _localizedValues[locale.languageCode]!['increaseTextSizeForBetterReadability']!;
  String get reduceAnimationsForMotionSensitivity => _localizedValues[locale.languageCode]!['reduceAnimationsForMotionSensitivity']!;
  String get customizeYourDashboardLayout => _localizedValues[locale.languageCode]!['customizeYourDashboardLayout']!;
  String get addNewWidgetsToYourDashboard => _localizedValues[locale.languageCode]!['addNewWidgetsToYourDashboard']!;
  String get thankYou => _localizedValues[locale.languageCode]!['thankYou']!;
  String get messageSentSuccessfully => _localizedValues[locale.languageCode]!['messageSentSuccessfully']!;
  String get failedToSendMessage => _localizedValues[locale.languageCode]!['failedToSendMessage']!;
  String get couldNotLaunch => _localizedValues[locale.languageCode]!['couldNotLaunch']!;
  String get errorLaunching => _localizedValues[locale.languageCode]!['errorLaunching']!;
  String get allSystemsNormal => _localizedValues[locale.languageCode]!['allSystemsNormal']!;
  String get keyReadings => _localizedValues[locale.languageCode]!['keyReadings']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get tapForMoreDetails => _localizedValues[locale.languageCode]!['tapForMoreDetails']!;

  // Home/Sensor Overview
  String get noSensorData => _localizedValues[locale.languageCode]!['noSensorData']!;
  String get offlineMode => _localizedValues[locale.languageCode]!['offlineMode']!;
  String get justNow => _localizedValues[locale.languageCode]!['justNow']!;
  String minutesAgo(int n) => _localizedValues[locale.languageCode]!['minutesAgo']!.replaceAll('{n}', n.toString());
  String hoursAgo(int n) => _localizedValues[locale.languageCode]!['hoursAgo']!.replaceAll('{n}', n.toString());
  String daysAgo(int n) => _localizedValues[locale.languageCode]!['daysAgo']!.replaceAll('{n}', n.toString());
  String get lowSoilMoisture => _localizedValues[locale.languageCode]!['lowSoilMoisture']!;
  String get lowHumidity => _localizedValues[locale.languageCode]!['lowHumidity']!;
  String get lowTemperature => _localizedValues[locale.languageCode]!['lowTemperature']!;
  String get highTemperature => _localizedValues[locale.languageCode]!['highTemperature']!;
  String get attentionDetected => _localizedValues[locale.languageCode]!['attentionDetected']!;
  String get multipleIssues => _localizedValues[locale.languageCode]!['multipleIssues']!;
  String get low => _localizedValues[locale.languageCode]!['low']!;
  String get high => _localizedValues[locale.languageCode]!['high']!;
  // Sensor Details
  String get current => _localizedValues[locale.languageCode]!['current']!;
  String get start => _localizedValues[locale.languageCode]!['start']!;
  String get end => _localizedValues[locale.languageCode]!['end']!;
  String get mid => _localizedValues[locale.languageCode]!['mid']!;
  String get tooCold => _localizedValues[locale.languageCode]!['tooCold']!;
  String get cool => _localizedValues[locale.languageCode]!['cool']!;
  String get warm => _localizedValues[locale.languageCode]!['warm']!;
  String get tooHot => _localizedValues[locale.languageCode]!['tooHot']!;
  String get veryDry => _localizedValues[locale.languageCode]!['veryDry']!;
  String get dry => _localizedValues[locale.languageCode]!['dry']!;
  String get humid => _localizedValues[locale.languageCode]!['humid']!;
  String get veryHumid => _localizedValues[locale.languageCode]!['veryHumid']!;
  String get soilMoistureLevels => _localizedValues[locale.languageCode]!['soilMoistureLevels']!;
  String get avgNA => _localizedValues[locale.languageCode]!['avgNA']!;
  String avgPercent(String avg) => _localizedValues[locale.languageCode]!['avgPercent']!.replaceAll('{avg}', avg);
  String sensorLabel(int n) => _localizedValues[locale.languageCode]!['sensorLabel']!.replaceAll('{n}', n.toString());
  String get criticallyDry => _localizedValues[locale.languageCode]!['criticallyDry']!;
  String get wet => _localizedValues[locale.languageCode]!['wet']!;
  String get criticallyWet => _localizedValues[locale.languageCode]!['criticallyWet']!;
  // Contact Us
  String get contactInformation => _localizedValues[locale.languageCode]!['contactInformation']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get sendUsMessage => _localizedValues[locale.languageCode]!['sendUsMessage']!;
  String get fullName => _localizedValues[locale.languageCode]!['fullName']!;
  String get enterFullName => _localizedValues[locale.languageCode]!['enterFullName']!;
  String get emailAddress => _localizedValues[locale.languageCode]!['emailAddress']!;
  String get emailHint => _localizedValues[locale.languageCode]!['emailHint']!;
  String get subject => _localizedValues[locale.languageCode]!['subject']!;
  String get subjectHint => _localizedValues[locale.languageCode]!['subjectHint']!;
  String get yourMessage => _localizedValues[locale.languageCode]!['yourMessage']!;
  String get messageHint => _localizedValues[locale.languageCode]!['messageHint']!;
  String get sending => _localizedValues[locale.languageCode]!['sending']!;
  String get sendMessage => _localizedValues[locale.languageCode]!['sendMessage']!;
  // Validation
  String get pleaseEnterName => _localizedValues[locale.languageCode]!['pleaseEnterName']!;
  String get nameMinLength => _localizedValues[locale.languageCode]!['nameMinLength']!;
  String get pleaseEnterEmail => _localizedValues[locale.languageCode]!['pleaseEnterEmail']!;
  String get enterValidEmail => _localizedValues[locale.languageCode]!['enterValidEmail']!;
  String get pleaseEnterSubject => _localizedValues[locale.languageCode]!['pleaseEnterSubject']!;
  String get pleaseEnterMessage => _localizedValues[locale.languageCode]!['pleaseEnterMessage']!;
  String get messageMinLength => _localizedValues[locale.languageCode]!['messageMinLength']!;
  String get errorOccurred => _localizedValues[locale.languageCode]!['errorOccurred']!;
  // Dashboard Widgets
  String get weather => _localizedValues[locale.languageCode]!['weather']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'ar', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Localized values
final Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'appTitle': 'AgriCure',
    'home': 'Home',
    'profile': 'Profile',
    'contactUs': 'Contact Us',
    'settings': 'Settings',
    'language': 'Language',
    'accessibility': 'Accessibility',
    'weatherOverview': 'Weather Overview',
    'sensorData': 'Sensor Data',
    'temperature': 'Temperature',
    'humidity': 'Humidity',
    'soilMoisture': 'Soil Moisture',
    'wind': 'Wind',
    'weatherCondition': 'Weather Condition',
    'lastUpdated': 'Last Updated',
    'refresh': 'Refresh',
    'loading': 'Loading...',
    'error': 'Error',
    'retry': 'Retry',
    'noData': 'No Data Available',
    'optimal': 'Optimal',
    'critical': 'Critical',
    'warning': 'Warning',
    'good': 'Good',
    'poor': 'Poor',
    'dashboard': 'Dashboard',
    'customize': 'Customize',
    'addWidget': 'Add Widget',
    'removeWidget': 'Remove Widget',
    'screenReader': 'Screen Reader',
    'highContrast': 'High Contrast',
    'largeText': 'Large Text',
    'reduceMotion': 'Reduce Motion',
    'welcomeBack': 'Welcome Back!',
    'farmStatus': "Here's your farm's current status.",
    'schedule': 'Schedule',
    'market': 'Market',
    'insights': 'Insights',
    'sensorOverview': 'Sensor Overview',
    'sensorDetails': 'Sensor Details',
    'marketPrices': 'Market Prices',
    'farmStats': 'Farm Stats',
    'quickTips': 'Quick Tips',
    'cropCalendar': 'Crop Calendar',
    'noUpcomingActivities': 'No upcoming activities.',
    'marketPricesNotAvailable': 'Market prices not available.',
    'farmStatsNotAvailable': 'Farm statistics not available.',
    'noTipsAvailable': 'No tips available right now.',
    'totalCrops': 'Total Crops',
    'landArea': 'Land Area',
    'waterUsage': 'Water Usage',
    'aboutAgriCure': 'About AgriCure',
    'appDescription': 'Your smart farming assistant, helping you manage and optimize your agricultural practices.',
    'logout': 'Logout',
    'cancel': 'Cancel',
    'confirmLogout': 'Are you sure you want to log out?',
    'version': 'Version',
    'privacyPolicy': 'Privacy Policy',
    'termsOfService': 'Terms of Service',
    'customizeDashboard': 'Customize Dashboard',
    'addWidgets': 'Add Widgets',
    'dashboardCustomizationComingSoon': 'Dashboard customization coming soon...',
    'widgetSelectionComingSoon': 'Widget selection coming soon...',
    'enableScreenReaderSupport': 'Enable screen reader support',
    'increaseContrastForBetterVisibility': 'Increase contrast for better visibility',
    'increaseTextSizeForBetterReadability': 'Increase text size for better readability',
    'reduceAnimationsForMotionSensitivity': 'Reduce animations for motion sensitivity',
    'customizeYourDashboardLayout': 'Customize your dashboard layout',
    'addNewWidgetsToYourDashboard': 'Add new widgets to your dashboard',
    'thankYou': 'Thank You!',
    'messageSentSuccessfully': 'Your message has been sent successfully. We will get back to you soon!',
    'failedToSendMessage': 'Failed to send message.',
    'couldNotLaunch': 'Could not launch',
    'errorLaunching': 'Error launching',
    'allSystemsNormal': 'All systems normal. Everything looks good!',
    'keyReadings': 'Key Readings',
    'ok': 'OK',
    'tapForMoreDetails': 'Tap for more details',
    'noSensorData': 'No sensor data available',
    'offlineMode': 'Offline mode',
    'justNow': 'Just now',
    'minutesAgo': '{n} minutes ago',
    'hoursAgo': '{n} hours ago',
    'daysAgo': '{n} days ago',
    'lowSoilMoisture': 'Low soil moisture',
    'lowHumidity': 'Low humidity',
    'lowTemperature': 'Low temperature',
    'highTemperature': 'High temperature',
    'attentionDetected': 'Attention detected',
    'multipleIssues': 'Multiple issues',
    'current': 'Current',
    'start': 'Start',
    'end': 'End',
    'mid': 'Mid',
    'tooCold': 'Too cold',
    'cool': 'Cool',
    'warm': 'Warm',
    'tooHot': 'Too hot',
    'veryDry': 'Very dry',
    'dry': 'Dry',
    'criticallyDry': 'Critically dry',
    'wet': 'Wet',
    'criticallyWet': 'Critically wet',
    'contactInformation': 'Contact Information',
    'email': 'Email',
    'phone': 'Phone',
    'address': 'Address',
    'sendUsMessage': 'Send us a message',
    'fullName': 'Full Name',
    'enterFullName': 'Enter your full name',
    'emailAddress': 'Email Address',
    'emailHint': 'Enter your email',
    'subject': 'Subject',
    'subjectHint': 'Enter a subject',
    'yourMessage': 'Your Message',
    'messageHint': 'Enter your message',
    'sending': 'Sending...',
    'sendMessage': 'Send Message',
    'pleaseEnterName': 'Please enter your name',
    'nameMinLength': 'Name must be at least 2 characters long',
    'pleaseEnterEmail': 'Please enter your email',
    'enterValidEmail': 'Enter a valid email',
    'pleaseEnterSubject': 'Please enter a subject',
    'pleaseEnterMessage': 'Please enter a message',
    'messageMinLength': 'Message must be at least 10 characters long',
    'errorOccurred': 'An error occurred',
    'weather': 'Weather',
  },
  'ar': {
    'appTitle': 'أجري كيور',
    'home': 'الرئيسية',
    'profile': 'الملف الشخصي',
    'contactUs': 'اتصل بنا',
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'accessibility': 'سهولة الوصول',
    'weatherOverview': 'نظرة عامة على الطقس',
    'sensorData': 'بيانات المستشعرات',
    'temperature': 'درجة الحرارة',
    'humidity': 'الرطوبة',
    'soilMoisture': 'رطوبة التربة',
    'wind': 'الرياح',
    'weatherCondition': 'حالة الطقس',
    'lastUpdated': 'آخر تحديث',
    'refresh': 'تحديث',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'retry': 'إعادة المحاولة',
    'noData': 'لا توجد بيانات متاحة',
    'optimal': 'مثالي',
    'critical': 'حرج',
    'warning': 'تحذير',
    'good': 'جيد',
    'poor': 'ضعيف',
    'dashboard': 'لوحة التحكم',
    'customize': 'تخصيص',
    'addWidget': 'إضافة عنصر',
    'removeWidget': 'إزالة عنصر',
    'screenReader': 'قارئ الشاشة',
    'highContrast': 'تباين عالٍ',
    'largeText': 'نص كبير',
    'reduceMotion': 'تقليل الحركة',
    'welcomeBack': 'مرحباً بعودتك!',
    'farmStatus': 'هذا هو الوضع الحالي لمزرعتك.',
    'schedule': 'الجدول الزمني',
    'market': 'السوق',
    'insights': 'الرؤى',
    'sensorOverview': 'نظرة عامة على المستشعرات',
    'sensorDetails': 'تفاصيل المستشعرات',
    'marketPrices': 'أسعار السوق',
    'farmStats': 'إحصائيات المزرعة',
    'quickTips': 'نصائح سريعة',
    'cropCalendar': 'تقويم المحاصيل',
    'noUpcomingActivities': 'لا توجد أنشطة قادمة.',
    'marketPricesNotAvailable': 'أسعار السوق غير متاحة.',
    'farmStatsNotAvailable': 'إحصائيات المزرعة غير متاحة.',
    'noTipsAvailable': 'لا توجد نصائح متاحة حالياً.',
    'totalCrops': 'إجمالي المحاصيل',
    'landArea': 'مساحة الأرض',
    'waterUsage': 'استخدام المياه',
    'aboutAgriCure': 'حول أجري كيور',
    'appDescription': 'مساعدك الذكي في الزراعة، يساعدك في إدارة وتحسين ممارساتك الزراعية.',
    'logout': 'تسجيل الخروج',
    'cancel': 'إلغاء',
    'confirmLogout': 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
    'version': 'الإصدار',
    'privacyPolicy': 'سياسة الخصوصية',
    'termsOfService': 'شروط الخدمة',
    'customizeDashboard': 'تخصيص لوحة التحكم',
    'addWidgets': 'إضافة عناصر',
    'dashboardCustomizationComingSoon': 'تخصيص لوحة التحكم قريباً...',
    'widgetSelectionComingSoon': 'اختيار العناصر قريباً...',
    'enableScreenReaderSupport': 'تمكين دعم قارئ الشاشة',
    'increaseContrastForBetterVisibility': 'زيادة التباين لرؤية أفضل',
    'increaseTextSizeForBetterReadability': 'زيادة حجم النص لقراءة أفضل',
    'reduceAnimationsForMotionSensitivity': 'تقليل الرسوم المتحركة لحساسية الحركة',
    'customizeYourDashboardLayout': 'تخصيص تخطيط لوحة التحكم',
    'addNewWidgetsToYourDashboard': 'إضافة عناصر جديدة إلى لوحة التحكم',
    'thankYou': 'شكراً لك!',
    'messageSentSuccessfully': 'تم إرسال رسالتك بنجاح. سنعود إليك قريباً!',
    'failedToSendMessage': 'فشل في إرسال الرسالة.',
    'couldNotLaunch': 'لا يمكن تشغيل',
    'errorLaunching': 'خطأ في التشغيل',
    'allSystemsNormal': 'جميع الأنظمة طبيعية. كل شيء يبدو جيدًا!',
    'keyReadings': 'القراءات الرئيسية',
    'ok': 'جيد',
    'tapForMoreDetails': 'اضغط لمزيد من التفاصيل',
    'noSensorData': 'لا توجد بيانات المستشعر متاحة',
    'offlineMode': 'وضع إيقاف التشغيل',
    'justNow': 'مؤخراً',
    'minutesAgo': '{n} دقيقة سابقاً',
    'hoursAgo': '{n} ساعة سابقاً',
    'daysAgo': '{n} يوم سابقاً',
    'lowSoilMoisture': 'رطوبة التربة ضعيفة',
    'lowHumidity': 'رطوبة الهواء ضعيفة',
    'lowTemperature': 'درجة الحرارة ضعيفة',
    'highTemperature': 'درجة الحرارة عالية',
    'attentionDetected': 'تم التوقع',
    'multipleIssues': 'عدة مشاكل',
    'current': 'الحالي',
    'start': 'بدء',
    'end': 'نهاية',
    'mid': 'وسط',
    'tooCold': 'بارد جداً',
    'cool': 'بارد',
    'warm': 'حار',
    'tooHot': 'حار جداً',
    'veryDry': 'جفاف جداً',
    'dry': 'جفاف',
    'criticallyDry': 'جفاف حرج',
    'wet': 'رطب',
    'criticallyWet': 'رطب حرج',
    'contactInformation': 'معلومات الاتصال',
    'email': 'البريد الإلكتروني',
    'phone': 'الهاتف',
    'address': 'العنوان',
    'sendUsMessage': 'أرسل لنا رسالة',
    'fullName': 'الاسم الكامل',
    'enterFullName': 'أدخل الاسم الكامل',
    'emailAddress': 'عنوان البريد الإلكتروني',
    'emailHint': 'أدخل عنوان البريد الإلكتروني',
    'subject': 'الموضوع',
    'subjectHint': 'أدخل موضوع',
    'yourMessage': 'الرسالة',
    'messageHint': 'أدخل الرسالة',
    'sending': 'جاري الإرسال...',
    'sendMessage': 'إرسال الرسالة',
    'pleaseEnterName': 'أدخل الاسم',
    'nameMinLength': 'يجب أن يكون الاسم أطول من 2 أحرف',
    'pleaseEnterEmail': 'أدخل بريدك الإلكتروني',
    'enterValidEmail': 'أدخل بريد إلكتروني صالح',
    'pleaseEnterSubject': 'أدخل الموضوع',
    'pleaseEnterMessage': 'أدخل الرسالة',
    'messageMinLength': 'يجب أن تكون الرسالة أطول من 10 أحرف',
    'errorOccurred': 'حدث خطأ',
    'weather': 'الطقس',
  },
  'es': {
    'appTitle': 'AgriCure',
    'home': 'Inicio',
    'profile': 'Perfil',
    'contactUs': 'Contáctanos',
    'settings': 'Configuración',
    'language': 'Idioma',
    'accessibility': 'Accesibilidad',
    'weatherOverview': 'Resumen del Clima',
    'sensorData': 'Datos del Sensor',
    'temperature': 'Temperatura',
    'humidity': 'Humedad',
    'soilMoisture': 'Humedad del Suelo',
    'wind': 'Viento',
    'weatherCondition': 'Condición del Clima',
    'lastUpdated': 'Última Actualización',
    'refresh': 'Actualizar',
    'loading': 'Cargando...',
    'error': 'Error',
    'retry': 'Reintentar',
    'noData': 'Sin Datos Disponibles',
    'optimal': 'Óptimo',
    'critical': 'Crítico',
    'warning': 'Advertencia',
    'good': 'Bueno',
    'poor': 'Pobre',
    'dashboard': 'Panel de Control',
    'customize': 'Personalizar',
    'addWidget': 'Agregar Widget',
    'removeWidget': 'Eliminar Widget',
    'screenReader': 'Lector de Pantalla',
    'highContrast': 'Alto Contraste',
    'largeText': 'Texto Grande',
    'reduceMotion': 'Reducir Movimiento',
    'welcomeBack': '¡Bienvenido de vuelta!',
    'farmStatus': 'Aquí está el estado actual de tu granja.',
    'schedule': 'Programa',
    'market': 'Mercado',
    'insights': 'Perspectivas',
    'sensorOverview': 'Resumen de Sensores',
    'sensorDetails': 'Detalles del Sensor',
    'marketPrices': 'Precios del Mercado',
    'farmStats': 'Estadísticas de la Granja',
    'quickTips': 'Consejos Rápidos',
    'cropCalendar': 'Calendario de Cultivos',
    'noUpcomingActivities': 'No hay actividades próximas.',
    'marketPricesNotAvailable': 'Precios del mercado no disponibles.',
    'farmStatsNotAvailable': 'Estadísticas de la granja no disponibles.',
    'noTipsAvailable': 'No hay consejos disponibles en este momento.',
    'totalCrops': 'Cultivos Totales',
    'landArea': 'Área de Tierra',
    'waterUsage': 'Uso de Agua',
    'aboutAgriCure': 'Acerca de AgriCure',
    'appDescription': 'Tu asistente agrícola inteligente, ayudándote a gestionar y optimizar tus prácticas agrícolas.',
    'logout': 'Cerrar Sesión',
    'cancel': 'Cancelar',
    'confirmLogout': '¿Estás seguro de que quieres cerrar sesión?',
    'version': 'Versión',
    'privacyPolicy': 'Política de Privacidad',
    'termsOfService': 'Términos de Servicio',
    'customizeDashboard': 'Personalizar Panel',
    'addWidgets': 'Agregar Widgets',
    'dashboardCustomizationComingSoon': 'Personalización del panel próximamente...',
    'widgetSelectionComingSoon': 'Selección de widgets próximamente...',
    'useLightTheme': 'Usar tema claro',
    'useDarkTheme': 'Usar tema oscuro',
    'followSystemSetting': 'Seguir configuración del sistema',
    'enableScreenReaderSupport': 'Habilitar soporte para lector de pantalla',
    'increaseContrastForBetterVisibility': 'Aumentar contraste para mejor visibilidad',
    'increaseTextSizeForBetterReadability': 'Aumentar tamaño de texto para mejor legibilidad',
    'reduceAnimationsForMotionSensitivity': 'Reducir animaciones para sensibilidad al movimiento',
    'customizeYourDashboardLayout': 'Personalizar el diseño de tu panel',
    'addNewWidgetsToYourDashboard': 'Agregar nuevos widgets a tu panel',
    'thankYou': '¡Gracias!',
    'messageSentSuccessfully': 'Tu mensaje ha sido enviado exitosamente. ¡Te responderemos pronto!',
    'failedToSendMessage': 'Error al enviar mensaje.',
    'couldNotLaunch': 'No se pudo abrir',
    'errorLaunching': 'Error al abrir',
    'allSystemsNormal': 'Todos los sistemas normales. ¡Todo se ve bien!',
    'keyReadings': 'Lecturas clave',
    'ok': 'OK',
    'tapForMoreDetails': 'Toca para más detalles',
    'noSensorData': 'No hay datos del sensor disponibles',
    'offlineMode': 'Modo sin conexión',
    'justNow': 'Hace poco',
    'minutesAgo': '{n} minutos atrás',
    'hoursAgo': '{n} horas atrás',
    'daysAgo': '{n} días atrás',
    'lowSoilMoisture': 'Baja humedad del suelo',
    'lowHumidity': 'Baja humedad',
    'lowTemperature': 'Baja temperatura',
    'highTemperature': 'Alta temperatura',
    'attentionDetected': 'Se ha detectado atención',
    'multipleIssues': 'Múltiples problemas',
    'current': 'Actual',
    'start': 'Inicio',
    'end': 'Fin',
    'mid': 'Medio',
    'tooCold': 'Demasiado frío',
    'cool': 'Frío',
    'warm': 'Caliente',
    'tooHot': 'Demasiado caliente',
    'veryDry': 'Demasiado seco',
    'dry': 'Seco',
    'criticallyDry': 'Seco crítico',
    'wet': 'Húmedo',
    'criticallyWet': 'Húmedo crítico',
    'contactInformation': 'Información de Contacto',
    'email': 'Correo Electrónico',
    'phone': 'Teléfono',
    'address': 'Dirección',
    'sendUsMessage': 'Envíanos un mensaje',
    'fullName': 'Nombre Completo',
    'enterFullName': 'Ingrese su nombre completo',
    'emailAddress': 'Dirección de Correo Electrónico',
    'emailHint': 'Ingrese su correo electrónico',
    'subject': 'Asunto',
    'subjectHint': 'Ingrese el asunto',
    'yourMessage': 'Su Mensaje',
    'messageHint': 'Ingrese su mensaje',
    'sending': 'Enviando...',
    'sendMessage': 'Enviar Mensaje',
    'pleaseEnterName': 'Por favor, ingrese su nombre',
    'nameMinLength': 'El nombre debe tener al menos 2 caracteres',
    'pleaseEnterEmail': 'Por favor, ingrese su correo electrónico',
    'enterValidEmail': 'Ingrese un correo electrónico válido',
    'pleaseEnterSubject': 'Por favor, ingrese el asunto',
    'pleaseEnterMessage': 'Por favor, ingrese el mensaje',
    'messageMinLength': 'El mensaje debe tener al menos 10 caracteres',
    'errorOccurred': 'Se produjo un error',
    'weather': 'Clima',
  },
  'fr': {
    'appTitle': 'AgriCure',
    'home': 'Accueil',
    'profile': 'Profil',
    'contactUs': 'Contactez-nous',
    'settings': 'Paramètres',
    'language': 'Langue',
    'accessibility': 'Accessibilité',
    'weatherOverview': 'Aperçu Météo',
    'sensorData': 'Données Capteur',
    'temperature': 'Température',
    'humidity': 'Humidité',
    'soilMoisture': 'Humidité du Sol',
    'wind': 'Vent',
    'weatherCondition': 'Condition Météo',
    'lastUpdated': 'Dernière Mise à Jour',
    'refresh': 'Actualiser',
    'loading': 'Chargement...',
    'error': 'Erreur',
    'retry': 'Réessayer',
    'noData': 'Aucune Donnée Disponible',
    'optimal': 'Optimal',
    'critical': 'Critique',
    'warning': 'Avertissement',
    'good': 'Bon',
    'poor': 'Mauvais',
    'dashboard': 'Tableau de Bord',
    'customize': 'Personnaliser',
    'addWidget': 'Ajouter Widget',
    'removeWidget': 'Supprimer Widget',
    'screenReader': 'Lecteur d\'Écran',
    'highContrast': 'Contraste Élevé',
    'largeText': 'Texte Large',
    'reduceMotion': 'Réduire le Mouvement',
    'welcomeBack': 'Bon Retour !',
    'farmStatus': 'Voici l\'état actuel de votre ferme.',
    'schedule': 'Programme',
    'market': 'Marché',
    'insights': 'Aperçus',
    'sensorOverview': 'Aperçu des Capteurs',
    'sensorDetails': 'Détails du Capteur',
    'marketPrices': 'Prix du Marché',
    'farmStats': 'Statistiques de la Ferme',
    'quickTips': 'Conseils Rapides',
    'cropCalendar': 'Calendrier des Cultures',
    'noUpcomingActivities': 'Aucune activité à venir.',
    'marketPricesNotAvailable': 'Prix du marché non disponibles.',
    'farmStatsNotAvailable': 'Statistiques de la ferme non disponibles.',
    'noTipsAvailable': 'Aucun conseil disponible pour le moment.',
    'totalCrops': 'Cultures Totales',
    'landArea': 'Superficie Terrestre',
    'waterUsage': 'Utilisation d\'Eau',
    'aboutAgriCure': 'À Propos d\'AgriCure',
    'appDescription': 'Votre assistant agricole intelligent, vous aidant à gérer et optimiser vos pratiques agricoles.',
    'logout': 'Déconnexion',
    'cancel': 'Annuler',
    'confirmLogout': 'Êtes-vous sûr de vouloir vous déconnecter ?',
    'version': 'Version',
    'privacyPolicy': 'Politique de Confidentialité',
    'termsOfService': 'Conditions d\'Utilisation',
    'customizeDashboard': 'Personnaliser le Tableau de Bord',
    'addWidgets': 'Ajouter des Widgets',
    'dashboardCustomizationComingSoon': 'Personnalisation du tableau de bord bientôt disponible...',
    'widgetSelectionComingSoon': 'Sélection de widgets bientôt disponible...',
    'useLightTheme': 'Utiliser le thème clair',
    'useDarkTheme': 'Utiliser le thème sombre',
    'followSystemSetting': 'Suivre le paramètre système',
    'enableScreenReaderSupport': 'Activer le support du lecteur d\'écran',
    'increaseContrastForBetterVisibility': 'Augmenter le contraste pour une meilleure visibilité',
    'increaseTextSizeForBetterReadability': 'Augmenter la taille du texte pour une meilleure lisibilité',
    'reduceAnimationsForMotionSensitivity': 'Réduire les animations pour la sensibilité au mouvement',
    'customizeYourDashboardLayout': 'Personnaliser la mise en page de votre tableau de bord',
    'addNewWidgetsToYourDashboard': 'Ajouter de nouveaux widgets à votre tableau de bord',
    'thankYou': 'Merci !',
    'messageSentSuccessfully': 'Votre message a été envoyé avec succès. Nous vous répondrons bientôt !',
    'failedToSendMessage': 'Échec de l\'envoi du message.',
    'couldNotLaunch': 'Impossible de lancer',
    'errorLaunching': 'Erreur lors du lancement',
    'allSystemsNormal': 'Tous les systèmes sont normaux. Tout semble bon!',
    'keyReadings': 'Lectures clés',
    'ok': 'OK',
    'tapForMoreDetails': 'Appuyez pour plus de détails',
    'noSensorData': 'Pas de données de capteur disponibles',
    'offlineMode': 'Mode hors ligne',
    'justNow': 'Il y a peu',
    'minutesAgo': '{n} minutes plus tôt',
    'hoursAgo': '{n} heures plus tôt',
    'daysAgo': '{n} jours plus tôt',
    'lowSoilMoisture': 'Faible humidité du sol',
    'lowHumidity': 'Faible humidité',
    'lowTemperature': 'Faible température',
    'highTemperature': 'Température élevée',
    'attentionDetected': 'Attention détectée',
    'multipleIssues': 'Plusieurs problèmes',
    'current': 'Actuel',
    'start': 'Début',
    'end': 'Fin',
    'mid': 'Milieu',
    'tooCold': 'Trop froid',
    'cool': 'Froid',
    'warm': 'Chaud',
    'tooHot': 'Trop chaud',
    'veryDry': 'Trop sec',
    'dry': 'Sec',
    'criticallyDry': 'Sec critique',
    'wet': 'Humide',
    'criticallyWet': 'Humide critique',
    'contactInformation': 'Informations de Contact',
    'email': 'Email',
    'phone': 'Téléphone',
    'address': 'Adresse',
    'sendUsMessage': 'Envoyez-nous un message',
    'fullName': 'Nom Complet',
    'enterFullName': 'Entrez votre nom complet',
    'emailAddress': 'Adresse Email',
    'emailHint': 'Entrez votre email',
    'subject': 'Sujet',
    'subjectHint': 'Entrez le sujet',
    'yourMessage': 'Votre Message',
    'messageHint': 'Entrez votre message',
    'sending': 'Envoi...',
    'sendMessage': 'Envoyer le Message',
    'pleaseEnterName': 'Veuillez entrer votre nom',
    'nameMinLength': 'Le nom doit comporter au moins 2 caractères',
    'pleaseEnterEmail': 'Veuillez entrer votre email',
    'enterValidEmail': 'Entrez un email valide',
    'pleaseEnterSubject': 'Veuillez entrer le sujet',
    'pleaseEnterMessage': 'Veuillez entrer le message',
    'messageMinLength': 'Le message doit comporter au moins 10 caractères',
    'errorOccurred': 'Erreur survenue',
    'weather': 'Météo',
  },
  'zh': {
    'appTitle': '农业护理',
    'home': '首页',
    'profile': '个人资料',
    'contactUs': '联系我们',
    'settings': '设置',
    'language': '语言',
    'accessibility': '无障碍',
    'weatherOverview': '天气概览',
    'sensorData': '传感器数据',
    'temperature': '温度',
    'humidity': '湿度',
    'soilMoisture': '土壤湿度',
    'wind': '风',
    'weatherCondition': '天气状况',
    'lastUpdated': '最后更新',
    'refresh': '刷新',
    'loading': '加载中...',
    'error': '错误',
    'retry': '重试',
    'noData': '无可用数据',
    'optimal': '最佳',
    'critical': '严重',
    'warning': '警告',
    'good': '良好',
    'poor': '差',
    'dashboard': '仪表板',
    'customize': '自定义',
    'addWidget': '添加小部件',
    'removeWidget': '移除小部件',
    'screenReader': '屏幕阅读器',
    'highContrast': '高对比度',
    'largeText': '大字体',
    'reduceMotion': '减少动画',
    'welcomeBack': '欢迎回来！',
    'farmStatus': '这是您农场的当前状态。',
    'schedule': '日程安排',
    'market': '市场',
    'insights': '洞察',
    'sensorOverview': '传感器概览',
    'sensorDetails': '传感器详情',
    'marketPrices': '市场价格',
    'farmStats': '农场统计',
    'quickTips': '快速提示',
    'cropCalendar': '作物日历',
    'noUpcomingActivities': '暂无即将进行的活动。',
    'marketPricesNotAvailable': '市场价格不可用。',
    'farmStatsNotAvailable': '农场统计不可用。',
    'noTipsAvailable': '目前没有可用的提示。',
    'totalCrops': '总作物',
    'landArea': '土地面积',
    'waterUsage': '用水量',
    'aboutAgriCure': '关于农业护理',
    'appDescription': '您的智能农业助手，帮助您管理和优化农业实践。',
    'logout': '退出登录',
    'cancel': '取消',
    'confirmLogout': '您确定要退出登录吗？',
    'version': '版本',
    'privacyPolicy': '隐私政策',
    'termsOfService': '服务条款',
    'customizeDashboard': '自定义仪表板',
    'addWidgets': '添加小部件',
    'dashboardCustomizationComingSoon': '仪表板自定义即将推出...',
    'widgetSelectionComingSoon': '小部件选择即将推出...',
    'useLightTheme': '使用浅色主题',
    'useDarkTheme': '使用深色主题',
    'followSystemSetting': '跟随系统设置',
    'enableScreenReaderSupport': '启用屏幕阅读器支持',
    'increaseContrastForBetterVisibility': '增加对比度以提高可见性',
    'increaseTextSizeForBetterReadability': '增加文本大小以提高可读性',
    'reduceAnimationsForMotionSensitivity': '减少动画以应对运动敏感',
    'customizeYourDashboardLayout': '自定义您的仪表板布局',
    'addNewWidgetsToYourDashboard': '向您的仪表板添加新的小部件',
    'thankYou': '谢谢！',
    'messageSentSuccessfully': '您的消息已成功发送。我们会尽快回复您！',
    'failedToSendMessage': '发送消息失败。',
    'couldNotLaunch': '无法启动',
    'errorLaunching': '启动时出错',
    'allSystemsNormal': '所有系统正常。一切看起来都很好！',
    'keyReadings': '关键读数',
    'ok': '正常',
    'tapForMoreDetails': '点击查看更多详情',
    'noSensorData': '无可用传感器数据',
    'offlineMode': '离线模式',
    'justNow': '刚刚',
    'minutesAgo': '{n}分钟前',
    'hoursAgo': '{n}小时前',
    'daysAgo': '{n}天前',
    'lowSoilMoisture': '低土壤湿度',
    'lowHumidity': '低湿度',
    'lowTemperature': '低温',
    'highTemperature': '高温',
    'attentionDetected': '已检测到注意力',
    'multipleIssues': '多个问题',
    'current': '当前',
    'start': '开始',
    'end': '结束',
    'mid': '中间',
    'tooCold': '过冷',
    'cool': '凉爽',
    'warm': '温暖',
    'tooHot': '过热',
    'veryDry': '极干',
    'dry': '干',
    'criticallyDry': '极度干旱',
    'wet': '湿润',
    'criticallyWet': '极度湿润',
    'contactInformation': '联系信息',
    'email': '电子邮件',
    'phone': '电话',
    'address': '地址',
    'sendUsMessage': '给我们发送消息',
    'fullName': '全名',
    'enterFullName': '输入您的全名',
    'emailAddress': '电子邮件地址',
    'emailHint': '输入您的电子邮件',
    'subject': '主题',
    'subjectHint': '输入主题',
    'yourMessage': '您的消息',
    'messageHint': '输入您的消息',
    'sending': '发送中...',
    'sendMessage': '发送消息',
    'pleaseEnterName': '请输入您的姓名',
    'nameMinLength': '姓名长度至少需要2个字符',
    'pleaseEnterEmail': '请输入您的电子邮件',
    'enterValidEmail': '请输入有效的电子邮件',
    'pleaseEnterSubject': '请输入主题',
    'pleaseEnterMessage': '请输入消息',
    'messageMinLength': '消息长度至少需要10个字符',
    'errorOccurred': '发生错误',
    'weather': '天气',
  },
};

// Language provider
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('en', '');
  bool _isInitialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      
      if (languageCode != null && AppLocalizations.supportedLocales.any((locale) => locale.languageCode == languageCode)) {
        _locale = Locale(languageCode, '');
      }
    } catch (e) {
      print('Error loading language preference: $e');
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }
} 