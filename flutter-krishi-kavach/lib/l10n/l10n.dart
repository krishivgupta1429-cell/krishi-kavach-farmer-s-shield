import 'package:flutter/material.dart';

/// Localization configuration
class L10n {
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
  ];
  
  static const Locale defaultLocale = Locale('en');
}

/// Centralized app localization strings
/// This is a simplified approach; for production, use ARB files with flutter_intl
class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  /// Get current language code
  String get languageCode => locale.languageCode;
  
  /// Check if current locale is Hindi
  bool get isHindi => locale.languageCode == 'hi';
  
  // ==================== COMMON ====================
  
  String get appName => _t('Krishi Kavach', 'कृषि कवच');
  String get tagline => _t('Scan leaf. Know disease. Save crop.', 'पत्ता स्कैन करें। रोग जानें। फसल बचाएं।');
  String get continueBtn => _t('Continue', 'आगे बढ़ें');
  String get back => _t('Back', 'वापस');
  String get next => _t('Next', 'अगला');
  String get skip => _t('Skip', 'छोड़ें');
  String get done => _t('Done', 'पूर्ण');
  String get save => _t('Save', 'सहेजें');
  String get cancel => _t('Cancel', 'रद्द करें');
  String get ok => _t('OK', 'ठीक है');
  String get retry => _t('Retry', 'पुनः प्रयास करें');
  String get loading => _t('Loading...', 'लोड हो रहा है...');
  String get error => _t('Error', 'त्रुटि');
  String get success => _t('Success', 'सफल');
  
  // ==================== AUTH ====================
  
  String get login => _t('Login', 'लॉगिन');
  String get signup => _t('Sign Up', 'साइन अप');
  String get logout => _t('Logout', 'लॉगआउट');
  String get mobileNumber => _t('Mobile Number', 'मोबाइल नंबर');
  String get enterMobile => _t('Enter your 10-digit mobile number', 'अपना 10 अंकों का मोबाइल नंबर दर्ज करें');
  String get fullName => _t('Full Name', 'पूरा नाम');
  String get enterName => _t('Enter your full name', 'अपना पूरा नाम दर्ज करें');
  String get selectState => _t('Select State', 'राज्य चुनें');
  String get district => _t('District (Optional)', 'जिला (वैकल्पिक)');
  String get enterDistrict => _t('Enter your district', 'अपना जिला दर्ज करें');
  String get preferredLanguage => _t('Preferred Language', 'पसंदीदा भाषा');
  String get acceptTerms => _t('I accept the Terms & Conditions', 'मैं नियम और शर्तें स्वीकार करता हूं');
  String get createAccount => _t('Create Account', 'खाता बनाएं');
  String get alreadyHaveAccount => _t('Already have an account?', 'पहले से खाता है?');
  String get dontHaveAccount => _t("Don't have an account?", 'खाता नहीं है?');
  String get welcomeBack => _t('Welcome Back!', 'वापसी पर स्वागत है!');
  String get enterMobileToLogin => _t('Enter your mobile number to continue', 'जारी रखने के लिए अपना मोबाइल नंबर दर्ज करें');
  
  // ==================== ONBOARDING ====================
  
  String get tellUsAboutFarm => _t('Tell us about your farm', 'अपने खेत के बारे में बताएं');
  String get helpUsServeYou => _t('This helps us serve you better', 'इससे हमें आपकी बेहतर सेवा करने में मदद मिलती है');
  String get primaryCrop => _t('What is your primary crop?', 'आपकी मुख्य फसल क्या है?');
  String get searchCrop => _t('Search crops...', 'फसल खोजें...');
  String get farmSize => _t('What is your farm size?', 'आपके खेत का आकार क्या है?');
  String get irrigationType => _t('What type of irrigation do you use?', 'आप किस प्रकार की सिंचाई का उपयोग करते हैं?');
  String get issueFrequency => _t('How often do you face crop issues?', 'आपको कितनी बार फसल समस्याओं का सामना करना पड़ता है?');
  String get startUsingApp => _t('Start Using Krishi Kavach', 'कृषि कवच का उपयोग शुरू करें');
  String get stepOf => _t('Step', 'चरण');
  
  // ==================== HOME ====================
  
  String get home => _t('Home', 'होम');
  String get about => _t('About', 'जानकारी');
  String get profile => _t('Profile', 'प्रोफ़ाइल');
  String get openCamera => _t('Open Camera', 'कैमरा खोलें');
  String get uploadFromGallery => _t('Upload from Gallery', 'गैलरी से अपलोड करें');
  String get detectDisease => _t('Detect Disease', 'रोग का पता लगाएं');
  String get changePhoto => _t('Change Photo', 'फोटो बदलें');
  String get trustCues => _t('Fast • Simple • Farmer-first', 'तेज़ • सरल • किसान-प्रथम');
  String get scanLeafToStart => _t('Scan a leaf to get started', 'शुरू करने के लिए पत्ता स्कैन करें');
  String get analyzing => _t('Analyzing your leaf...', 'आपके पत्ते का विश्लेषण हो रहा है...');
  String get pleaseWait => _t('Please wait', 'कृपया प्रतीक्षा करें');
  
  // ==================== RESULT ====================
  
  String get result => _t('Result', 'परिणाम');
  String get crop => _t('Crop', 'फसल');
  String get disease => _t('Disease', 'रोग');
  String get confidence => _t('Confidence', 'विश्वास');
  String get remedies => _t('Remedies', 'उपाय');
  String get scanAnother => _t('Scan Another Leaf', 'एक और पत्ता स्कैन करें');
  String get saveResult => _t('Save Result', 'परिणाम सहेजें');
  String get share => _t('Share', 'शेयर करें');
  String get disclaimer => _t('This is guidance. For severe symptoms, consult a local expert.', 'यह मार्गदर्शन है। गंभीर लक्षणों के लिए, स्थानीय विशेषज्ञ से परामर्श करें।');
  String get healthy => _t('Healthy', 'स्वस्थ');
  String get healthyMessage => _t('Great news! Your plant looks healthy.', 'अच्छी खबर! आपका पौधा स्वस्थ दिखता है।');
  String get resultSaved => _t('Result saved to history', 'परिणाम इतिहास में सहेजा गया');
  
  // ==================== ERRORS ====================
  
  String get uploadClearLeaf => _t('Please upload a clear leaf photo', 'कृपया पत्ते की साफ़ फोटो अपलोड करें');
  String get noInternet => _t('No internet connection', 'कोई इंटरनेट कनेक्शन नहीं');
  String get apiError => _t('Something went wrong. Please try again.', 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।');
  String get cameraPermissionDenied => _t('Camera permission denied. Please enable in settings.', 'कैमरा अनुमति अस्वीकृत। कृपया सेटिंग्स में सक्षम करें।');
  String get galleryPermissionDenied => _t('Gallery permission denied. Please enable in settings.', 'गैलरी अनुमति अस्वीकृत। कृपया सेटिंग्स में सक्षम करें।');
  
  // ==================== ABOUT ====================
  
  String get aboutTitle => _t('About Krishi Kavach', 'कृषि कवच के बारे में');
  String get aboutDescription => _t(
    'Krishi Kavach is an AI-powered app that helps Indian farmers identify plant diseases quickly and easily. Just take a photo of a leaf, and get instant diagnosis with remedy suggestions.',
    'कृषि कवच एक AI-संचालित ऐप है जो भारतीय किसानों को पौधों की बीमारियों की जल्दी और आसानी से पहचान करने में मदद करता है। बस एक पत्ते की फोटो लें, और उपाय सुझावों के साथ तुरंत निदान प्राप्त करें।',
  );
  String get howToTakeGoodPhoto => _t('How to take a good photo', 'अच्छी फोटो कैसे लें');
  String get tip1 => _t('Use natural daylight', 'प्राकृतिक दिन की रोशनी का उपयोग करें');
  String get tip2 => _t('Keep the leaf in focus', 'पत्ते को फोकस में रखें');
  String get tip3 => _t('Capture the affected area clearly', 'प्रभावित क्षेत्र को स्पष्ट रूप से कैप्चर करें');
  String get vision => _t('Made for Indian Farmers 🇮🇳', 'भारतीय किसानों के लिए बनाया गया 🇮🇳');
  
  // ==================== PROFILE ====================
  
  String get editProfile => _t('Edit Profile', 'प्रोफ़ाइल संपादित करें');
  String get scanHistory => _t('Scan History', 'स्कैन इतिहास');
  String get noHistoryYet => _t('No scans yet', 'अभी तक कोई स्कैन नहीं');
  String get clearHistory => _t('Clear History', 'इतिहास साफ़ करें');
  String get logoutConfirm => _t('Are you sure you want to logout?', 'क्या आप वाकई लॉगआउट करना चाहते हैं?');
  
  // ==================== FARM SIZE ====================
  
  String get farmSmall => _t('Small (< 2 hectares)', 'छोटा (< 2 हेक्टेयर)');
  String get farmMedium => _t('Medium (2-10 hectares)', 'मध्यम (2-10 हेक्टेयर)');
  String get farmLarge => _t('Large (> 10 hectares)', 'बड़ा (> 10 हेक्टेयर)');
  
  // ==================== IRRIGATION ====================
  
  String get irrigationRainfed => _t('Rainfed', 'बारानी');
  String get irrigationCanal => _t('Canal', 'नहर');
  String get irrigationBorewell => _t('Borewell', 'बोरवेल');
  String get irrigationDrip => _t('Drip Irrigation', 'ड्रिप सिंचाई');
  String get irrigationOther => _t('Other', 'अन्य');
  
  // ==================== ISSUE FREQUENCY ====================
  
  String get frequencyRare => _t('Rarely', 'कभी-कभार');
  String get frequencySometimes => _t('Sometimes', 'कभी-कभी');
  String get frequencyOften => _t('Often', 'अक्सर');
  
  /// Helper method to return translated string based on locale
  String _t(String en, String hi) {
    return isHindi ? hi : en;
  }
}

/// Localization delegate
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
