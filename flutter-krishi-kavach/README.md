# Krishi Kavach - Flutter App Specification

## AI-Powered Plant Disease Detection for Indian Farmers

This is a complete, production-ready Flutter codebase for the Krishi Kavach mobile app.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── l10n/
│   ├── app_en.arb                     # English translations
│   ├── app_hi.arb                     # Hindi translations
│   └── l10n.dart                      # Localization setup
├── theme/
│   └── app_theme.dart                 # Material 3 agriculture theme
├── models/
│   └── prediction_result.dart         # API response model
├── services/
│   ├── prediction_service.dart        # API integration
│   └── storage_service.dart           # SharedPreferences helper
├── utils/
│   ├── constants.dart                 # API endpoints, configs
│   └── validators.dart                # Form validation
├── widgets/
│   ├── primary_button.dart            # Reusable CTA button
│   ├── language_toggle.dart           # EN/HI switch
│   ├── result_card.dart               # Disease result display
│   └── image_upload_area.dart         # Camera/gallery picker
└── screens/
    ├── splash_screen.dart             # Initial loading
    ├── login_screen.dart              # Mobile number login
    ├── signup_screen.dart             # Registration form
    ├── onboarding/
    │   └── onboarding_screen.dart     # Multi-step wizard
    ├── home_screen.dart               # Main scan interface
    ├── result_screen.dart             # Prediction display
    ├── about_screen.dart              # App info & tips
    └── profile_screen.dart            # User settings
```

---

## 🔧 Setup Instructions

### 1. Create Flutter Project
```bash
flutter create krishi_kavach
cd krishi_kavach
```

### 2. Update pubspec.yaml
```yaml
name: krishi_kavach
description: AI-powered plant disease detection for Indian farmers

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # State & Storage
  shared_preferences: ^2.2.2
  
  # Networking
  http: ^1.1.0
  
  # Image Handling
  image_picker: ^1.0.4
  
  # UI Enhancements
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0
  
  # Internationalization
  intl: ^0.18.1

flutter:
  uses-material-design: true
  generate: true  # For l10n

flutter_intl:
  enabled: true
  main_locale: en
  arb_dir: lib/l10n
```

### 3. Android Permissions (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### 4. iOS Permissions (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Krishi Kavach needs camera access to scan plant leaves</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Krishi Kavach needs gallery access to upload leaf photos</string>
```

---

## 🎨 Design System

### Color Palette (Agriculture-Inspired)
- **Primary Green**: `#2E7D32` (Fresh, growth)
- **Primary Light**: `#60AD5E`
- **Primary Dark**: `#005005`
- **Accent Warm**: `#FF8F00` (Harvest gold)
- **Background**: `#FAFDF7` (Soft cream-white)
- **Surface**: `#FFFFFF`
- **Error**: `#D32F2F`

### Typography
- Display: Google Fonts - Poppins (Bold)
- Body: Google Fonts - Noto Sans
- Hindi: Google Fonts - Noto Sans Devanagari

---

## 🚀 Key Features

1. **Gated Authentication Flow** - Login → Signup → Onboarding → Home
2. **Bilingual Support** - Real-time EN/HI toggle with persistence
3. **Camera/Gallery Integration** - High-quality image capture
4. **REST API Integration** - Configurable prediction endpoint
5. **Robust Error Handling** - Network, permissions, invalid images
6. **Local History** - Save & review past scans
7. **Farmer-Friendly UI** - Large targets, high contrast, minimal text

---

## 📱 Run the App

```bash
flutter pub get
flutter run
```

For release build:
```bash
flutter build apk --release
```

---

## 📄 License

MIT License - Built for Indian farmers 🌾
