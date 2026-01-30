import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../l10n/l10n.dart';

/// Language toggle widget for switching between English and Hindi
/// Persists selection to local storage and updates app locale instantly
class LanguageToggle extends StatelessWidget {
  final bool showLabel;
  final double? iconSize;
  
  const LanguageToggle({
    super.key,
    this.showLabel = true,
    this.iconSize,
  });
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isHindi = loc.isHindi;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            label: 'EN',
            isSelected: !isHindi,
            onTap: () => _setLocale(context, 'en'),
          ),
          _LanguageOption(
            label: 'हि',
            isSelected: isHindi,
            onTap: () => _setLocale(context, 'hi'),
          ),
        ],
      ),
    );
  }
  
  void _setLocale(BuildContext context, String langCode) {
    KrishiKavachApp.setLocale(context, Locale(langCode));
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Compact language toggle for tight spaces (e.g., in app bars)
class CompactLanguageToggle extends StatelessWidget {
  const CompactLanguageToggle({super.key});
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isHindi = loc.isHindi;
    
    return IconButton(
      onPressed: () {
        final newLang = isHindi ? 'en' : 'hi';
        KrishiKavachApp.setLocale(context, Locale(newLang));
      },
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: AppTheme.primaryGreen.withOpacity(0.3),
          ),
        ),
        child: Text(
          isHindi ? 'EN' : 'हि',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      tooltip: isHindi ? 'Switch to English' : 'हिंदी में बदलें',
    );
  }
}
