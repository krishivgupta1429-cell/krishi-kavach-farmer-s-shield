/// API Configuration
/// Change this to your actual prediction API endpoint
class ApiConstants {
  /// Base URL for the prediction API
  /// IMPORTANT: Replace with your actual API server URL
  static const String baseUrl = 'https://api.example.com';
  
  /// Prediction endpoint path
  static const String predictEndpoint = '/predict';
  
  /// Full prediction URL
  static String get predictUrl => '$baseUrl$predictEndpoint';
  
  /// Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);
  
  /// Maximum image size in bytes (5MB)
  static const int maxImageSize = 5 * 1024 * 1024;
}

/// Storage Keys for SharedPreferences
class StorageKeys {
  // Auth & Profile
  static const String isLoggedIn = 'is_logged_in';
  static const String userName = 'user_name';
  static const String userMobile = 'user_mobile';
  static const String userState = 'user_state';
  static const String userDistrict = 'user_district';
  
  // Onboarding
  static const String onboardingComplete = 'onboarding_complete';
  static const String primaryCrop = 'primary_crop';
  static const String farmSize = 'farm_size';
  static const String irrigationType = 'irrigation_type';
  static const String issueFrequency = 'issue_frequency';
  
  // Preferences
  static const String language = 'preferred_language';
  
  // History
  static const String scanHistory = 'scan_history';
}

/// Indian States List
class IndianStates {
  static const List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
}

/// Common Crops in India
class CommonCrops {
  static const List<String> crops = [
    'Rice (धान)',
    'Wheat (गेहूं)',
    'Maize (मक्का)',
    'Cotton (कपास)',
    'Sugarcane (गन्ना)',
    'Tomato (टमाटर)',
    'Potato (आलू)',
    'Onion (प्याज)',
    'Chili (मिर्च)',
    'Brinjal (बैंगन)',
    'Cabbage (पत्तागोभी)',
    'Cauliflower (फूलगोभी)',
    'Okra (भिंडी)',
    'Soybean (सोयाबीन)',
    'Groundnut (मूंगफली)',
    'Mustard (सरसों)',
    'Turmeric (हल्दी)',
    'Ginger (अदरक)',
    'Banana (केला)',
    'Mango (आम)',
    'Papaya (पपीता)',
    'Grapes (अंगूर)',
    'Orange (संतरा)',
    'Apple (सेब)',
    'Coconut (नारियल)',
    'Tea (चाय)',
    'Coffee (कॉफी)',
    'Other (अन्य)',
  ];
}

/// Farm Size Options
class FarmSizeOptions {
  static const Map<String, String> sizes = {
    'small': 'Small (< 2 hectares)',
    'medium': 'Medium (2-10 hectares)',
    'large': 'Large (> 10 hectares)',
  };
  
  static const Map<String, String> sizesHindi = {
    'small': 'छोटा (< 2 हेक्टेयर)',
    'medium': 'मध्यम (2-10 हेक्टेयर)',
    'large': 'बड़ा (> 10 हेक्टेयर)',
  };
}

/// Irrigation Types
class IrrigationTypes {
  static const Map<String, String> types = {
    'rainfed': 'Rainfed (बारानी)',
    'canal': 'Canal (नहर)',
    'borewell': 'Borewell (बोरवेल)',
    'drip': 'Drip Irrigation (ड्रिप)',
    'other': 'Other (अन्य)',
  };
}

/// Issue Frequency Options
class IssueFrequency {
  static const Map<String, String> frequency = {
    'rare': 'Rarely (कभी-कभार)',
    'sometimes': 'Sometimes (कभी-कभी)',
    'often': 'Often (अक्सर)',
  };
}
