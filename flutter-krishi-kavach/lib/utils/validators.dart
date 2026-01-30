/// Form validation utilities for Krishi Kavach
class Validators {
  /// Validates Indian mobile number (10 digits, starts with 6-9)
  static String? validateMobile(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please enter mobile number';
      }
      return null;
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleaned.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleaned)) {
      return 'Please enter a valid Indian mobile number';
    }
    
    return null;
  }
  
  /// Validates full name (minimum 2 characters, letters and spaces only)
  static String? validateName(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please enter your name';
      }
      return null;
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    // Allow letters, spaces, and common name characters
    if (!RegExp(r"^[a-zA-Z\s.']+$").hasMatch(value.trim())) {
      return 'Please enter a valid name';
    }
    
    return null;
  }
  
  /// Validates state selection
  static String? validateState(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please select your state';
      }
      return null;
    }
    return null;
  }
  
  /// Validates crop selection
  static String? validateCrop(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please select your primary crop';
      }
      return null;
    }
    return null;
  }
  
  /// Validates that terms are accepted
  static String? validateTermsAccepted(bool? accepted) {
    if (accepted != true) {
      return 'Please accept the terms and conditions';
    }
    return null;
  }
  
  /// Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
  
  /// Validates that a selection is made from options
  static String? validateSelection(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }
    return null;
  }
}
