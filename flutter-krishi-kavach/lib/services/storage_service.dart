import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/prediction_result.dart';

/// Service for managing local storage with SharedPreferences
/// Handles auth state, user profile, onboarding data, and scan history
class StorageService {
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  // ==================== AUTH STATE ====================
  
  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(StorageKeys.isLoggedIn) ?? false;
  }
  
  /// Set login state
  Future<bool> setLoggedIn(bool value) {
    return _prefs.setBool(StorageKeys.isLoggedIn, value);
  }
  
  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _prefs.getBool(StorageKeys.onboardingComplete) ?? false;
  }
  
  /// Set onboarding complete state
  Future<bool> setOnboardingComplete(bool value) {
    return _prefs.setBool(StorageKeys.onboardingComplete, value);
  }
  
  // ==================== USER PROFILE ====================
  
  /// Get user's full name
  String getUserName() {
    return _prefs.getString(StorageKeys.userName) ?? '';
  }
  
  /// Set user's full name
  Future<bool> setUserName(String name) {
    return _prefs.setString(StorageKeys.userName, name);
  }
  
  /// Get user's mobile number
  String getUserMobile() {
    return _prefs.getString(StorageKeys.userMobile) ?? '';
  }
  
  /// Set user's mobile number
  Future<bool> setUserMobile(String mobile) {
    return _prefs.setString(StorageKeys.userMobile, mobile);
  }
  
  /// Get user's state
  String getUserState() {
    return _prefs.getString(StorageKeys.userState) ?? '';
  }
  
  /// Set user's state
  Future<bool> setUserState(String state) {
    return _prefs.setString(StorageKeys.userState, state);
  }
  
  /// Get user's district
  String getUserDistrict() {
    return _prefs.getString(StorageKeys.userDistrict) ?? '';
  }
  
  /// Set user's district
  Future<bool> setUserDistrict(String district) {
    return _prefs.setString(StorageKeys.userDistrict, district);
  }
  
  // ==================== ONBOARDING DATA ====================
  
  /// Get primary crop
  String getPrimaryCrop() {
    return _prefs.getString(StorageKeys.primaryCrop) ?? '';
  }
  
  /// Set primary crop
  Future<bool> setPrimaryCrop(String crop) {
    return _prefs.setString(StorageKeys.primaryCrop, crop);
  }
  
  /// Get farm size
  String getFarmSize() {
    return _prefs.getString(StorageKeys.farmSize) ?? '';
  }
  
  /// Set farm size
  Future<bool> setFarmSize(String size) {
    return _prefs.setString(StorageKeys.farmSize, size);
  }
  
  /// Get irrigation type
  String getIrrigationType() {
    return _prefs.getString(StorageKeys.irrigationType) ?? '';
  }
  
  /// Set irrigation type
  Future<bool> setIrrigationType(String type) {
    return _prefs.setString(StorageKeys.irrigationType, type);
  }
  
  /// Get issue frequency
  String getIssueFrequency() {
    return _prefs.getString(StorageKeys.issueFrequency) ?? '';
  }
  
  /// Set issue frequency
  Future<bool> setIssueFrequency(String frequency) {
    return _prefs.setString(StorageKeys.issueFrequency, frequency);
  }
  
  // ==================== LANGUAGE PREFERENCE ====================
  
  /// Get preferred language (default: 'en')
  String getLanguage() {
    return _prefs.getString(StorageKeys.language) ?? 'en';
  }
  
  /// Set preferred language
  Future<bool> setLanguage(String langCode) {
    return _prefs.setString(StorageKeys.language, langCode);
  }
  
  // ==================== SCAN HISTORY ====================
  
  /// Get scan history as list of PredictionResult
  List<PredictionResult> getScanHistory() {
    final historyJson = _prefs.getString(StorageKeys.scanHistory);
    if (historyJson == null || historyJson.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded
          .map((item) => PredictionResult.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  /// Add a scan result to history
  Future<bool> addToScanHistory(PredictionResult result) async {
    final history = getScanHistory();
    
    // Add new result with timestamp
    final resultWithTime = result.copyWith(
      scannedAt: DateTime.now(),
    );
    
    history.insert(0, resultWithTime);
    
    // Keep only last 50 scans
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    final encoded = json.encode(
      history.map((r) => r.toJson()).toList(),
    );
    
    return _prefs.setString(StorageKeys.scanHistory, encoded);
  }
  
  /// Clear scan history
  Future<bool> clearScanHistory() {
    return _prefs.remove(StorageKeys.scanHistory);
  }
  
  // ==================== SIGNUP HELPER ====================
  
  /// Save all signup data at once
  Future<void> saveSignupData({
    required String name,
    required String mobile,
    required String state,
    String? district,
    required String language,
  }) async {
    await Future.wait([
      setUserName(name),
      setUserMobile(mobile),
      setUserState(state),
      if (district != null) setUserDistrict(district),
      setLanguage(language),
      setLoggedIn(true),
    ]);
  }
  
  /// Save all onboarding data at once
  Future<void> saveOnboardingData({
    required String primaryCrop,
    required String farmSize,
    required String irrigationType,
    required String issueFrequency,
  }) async {
    await Future.wait([
      setPrimaryCrop(primaryCrop),
      setFarmSize(farmSize),
      setIrrigationType(irrigationType),
      setIssueFrequency(issueFrequency),
      setOnboardingComplete(true),
    ]);
  }
  
  // ==================== LOGOUT ====================
  
  /// Clear all user data (logout)
  Future<void> logout() async {
    await _prefs.clear();
  }
  
  /// Get metadata for API requests
  Map<String, String> getMetadataForPrediction() {
    return {
      'crop': getPrimaryCrop(),
      'state': getUserState(),
      'district': getUserDistrict(),
      'farm_size': getFarmSize(),
      'irrigation': getIrrigationType(),
    };
  }
}
