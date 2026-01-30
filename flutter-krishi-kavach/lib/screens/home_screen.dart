import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/prediction_service.dart';
import '../models/prediction_result.dart';
import '../widgets/language_toggle.dart';
import '../widgets/primary_button.dart';
import '../widgets/image_upload_area.dart';
import '../l10n/l10n.dart';

/// Main home screen with leaf scanning functionality
class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  
  const HomeScreen({super.key, required this.storageService});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  File? _selectedImage;
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      
      String message = loc.apiError;
      if (e.toString().contains('camera_access_denied')) {
        message = loc.cameraPermissionDenied;
      } else if (e.toString().contains('photo_access_denied')) {
        message = loc.galleryPermissionDenied;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }
  
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;
    
    setState(() => _isAnalyzing = true);
    
    try {
      final result = await PredictionService.predictDisease(
        imageFile: _selectedImage!,
        metadata: widget.storageService.getMetadataForPrediction(),
      );
      
      if (!mounted) return;
      
      if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: AppTheme.error,
          ),
        );
      } else {
        Navigator.of(context).pushNamed(
          '/result',
          arguments: result.toJson(),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).apiError),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }
  
  void _clearImage() {
    setState(() => _selectedImage = null);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildAboutContent();
      case 2:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }
  
  Widget _buildHomeContent() {
    final loc = AppLocalizations.of(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(loc),
            
            // Hero section
            _buildHeroSection(loc),
            
            // Upload area
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: _selectedImage == null
                  ? _buildUploadButtons(loc)
                  : _buildImagePreview(loc),
            ),
            
            // Trust cues
            _buildTrustCues(loc),
            
            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingM),
          
          // App name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.appName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                Text(
                  'कृषि कवच',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          // Language toggle
          const LanguageToggle(),
          
          const SizedBox(width: AppTheme.spacingS),
          
          // Profile icon
          IconButton(
            onPressed: () => setState(() => _currentIndex = 2),
            icon: const CircleAvatar(
              backgroundColor: AppTheme.surfaceVariant,
              child: Icon(
                Icons.person_outline_rounded,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeroSection(AppLocalizations loc) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.eco_rounded,
            size: 48,
            color: Colors.white70,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            loc.tagline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUploadButtons(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Leaf icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              size: 40,
              color: AppTheme.primaryGreen,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          Text(
            loc.scanLeafToStart,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingXL),
          
          // Camera button
          PrimaryButton(
            label: loc.openCamera,
            icon: Icons.camera_alt_rounded,
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Gallery button
          PrimaryButton(
            label: loc.uploadFromGallery,
            icon: Icons.photo_library_rounded,
            onPressed: () => _pickImage(ImageSource.gallery),
            isOutlined: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildImagePreview(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          // Image preview
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
                
                // Analyzing overlay
                if (_isAnalyzing)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.analyzing,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Change photo button
                if (!_isAnalyzing)
                  Positioned(
                    top: AppTheme.spacingM,
                    right: AppTheme.spacingM,
                    child: Material(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      child: InkWell(
                        onTap: _clearImage,
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                loc.changePhoto,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Detect button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: SecondaryButton(
              label: loc.detectDisease,
              icon: Icons.search_rounded,
              onPressed: _isAnalyzing ? null : _analyzeImage,
              isLoading: _isAnalyzing,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrustCues(AppLocalizations loc) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 18,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 8),
          Text(
            loc.trustCues,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutContent() {
    // Delegate to AboutScreen (imported separately)
    return const Center(
      child: Text('About Screen'),
    );
  }
  
  Widget _buildProfileContent() {
    // Delegate to ProfileScreen (imported separately)
    return const Center(
      child: Text('Profile Screen'),
    );
  }
  
  Widget _buildBottomNav() {
    final loc = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: loc.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline_rounded),
            label: loc.about,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: loc.profile,
          ),
        ],
      ),
    );
  }
}
