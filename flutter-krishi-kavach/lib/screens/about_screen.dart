import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/language_toggle.dart';
import '../l10n/l10n.dart';

/// About screen explaining app usage and tips
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(loc.about),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppTheme.spacingM),
            child: LanguageToggle(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero section
              _buildHeroSection(context, loc),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // About description
              _buildAboutCard(context, loc),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Photo tips
              _buildPhotoTipsCard(context, loc),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Vision statement
              _buildVisionCard(context, loc),
              
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeroSection(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            loc.appName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'कृषि कवच',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutCard(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                loc.aboutTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            loc.aboutDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhotoTipsCard(BuildContext context, AppLocalizations loc) {
    final tips = [
      {'icon': Icons.wb_sunny_outlined, 'text': loc.tip1},
      {'icon': Icons.center_focus_strong_outlined, 'text': loc.tip2},
      {'icon': Icons.crop_free_rounded, 'text': loc.tip3},
    ];
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: AppTheme.accentOrange,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                loc.howToTakeGoodPhoto,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: AppTheme.accentOrange,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    tip['text'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildVisionCard(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loc.vision,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
