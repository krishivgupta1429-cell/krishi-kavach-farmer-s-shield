import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../l10n/l10n.dart';
import 'primary_button.dart';

/// Image upload area with camera and gallery options
/// Shows preview after selection with option to change
class ImageUploadArea extends StatefulWidget {
  final Function(File image) onImageSelected;
  final VoidCallback? onImageRemoved;
  final File? selectedImage;
  
  const ImageUploadArea({
    super.key,
    required this.onImageSelected,
    this.onImageRemoved,
    this.selectedImage,
  });
  
  @override
  State<ImageUploadArea> createState() => _ImageUploadAreaState();
}

class _ImageUploadAreaState extends State<ImageUploadArea> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _errorMessage;
  
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        widget.onImageSelected(file);
      }
    } catch (e) {
      final loc = AppLocalizations.of(context);
      
      if (e.toString().contains('camera_access_denied')) {
        setState(() {
          _errorMessage = loc.cameraPermissionDenied;
        });
      } else if (e.toString().contains('photo_access_denied')) {
        setState(() {
          _errorMessage = loc.galleryPermissionDenied;
        });
      } else {
        setState(() {
          _errorMessage = loc.apiError;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (widget.selectedImage != null) {
      return _buildPreview(context, loc);
    }
    
    return _buildUploadArea(context, loc);
  }
  
  Widget _buildUploadArea(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Leaf illustration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              size: 50,
              color: AppTheme.primaryGreen,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Instruction text
          Text(
            loc.scanLeafToStart,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingXL),
          
          // Camera button
          PrimaryButton(
            label: loc.openCamera,
            icon: Icons.camera_alt_rounded,
            onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
            isLoading: _isLoading,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Gallery button
          PrimaryButton(
            label: loc.uploadFromGallery,
            icon: Icons.photo_library_rounded,
            onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
            isOutlined: true,
          ),
          
          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: AppTheme.spacingM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppTheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPreview(BuildContext context, AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image preview
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  widget.selectedImage!,
                  fit: BoxFit.cover,
                ),
                
                // Change photo overlay button
                Positioned(
                  top: AppTheme.spacingM,
                  right: AppTheme.spacingM,
                  child: Material(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                    child: InkWell(
                      onTap: widget.onImageRemoved,
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
              onPressed: () {
                // This will be handled by the parent widget
                // The button press should trigger the prediction
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple image preview with change option
class ImagePreviewCard extends StatelessWidget {
  final File image;
  final VoidCallback onDetect;
  final VoidCallback onChangePhoto;
  final bool isAnalyzing;
  
  const ImagePreviewCard({
    super.key,
    required this.image,
    required this.onDetect,
    required this.onChangePhoto,
    this.isAnalyzing = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image preview
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
                
                // Analyzing overlay
                if (isAnalyzing)
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
                if (!isAnalyzing)
                  Positioned(
                    top: AppTheme.spacingM,
                    right: AppTheme.spacingM,
                    child: Material(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      child: InkWell(
                        onTap: onChangePhoto,
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
              onPressed: isAnalyzing ? null : onDetect,
              isLoading: isAnalyzing,
            ),
          ),
        ],
      ),
    );
  }
}
