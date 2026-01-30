import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Farmer-friendly primary action button with large touch target
/// Supports icons, loading state, and multiple variants
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final EdgeInsets? padding;
  
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 60.0; // Large touch target
    
    if (isOutlined) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppTheme.primaryGreen,
            side: BorderSide(
              color: backgroundColor ?? AppTheme.primaryGreen,
              width: 2,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: _buildContent(context, isOutlined: true),
        ),
      );
    }
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: onPressed != null && !isLoading
              ? AppTheme.buttonShadow
              : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.primaryGreen,
            foregroundColor: textColor ?? AppTheme.textOnPrimary,
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade600,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, {bool isOutlined = false}) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppTheme.primaryGreen : Colors.white,
          ),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    
    return Text(
      label,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Secondary button with accent color (for alternate actions)
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: AppTheme.accentOrange,
      textColor: Colors.white,
    );
  }
}

/// Text link button for navigation or minor actions
class LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  
  const LinkButton({
    super.key,
    required this.label,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryGreen,
        ),
      ),
    );
  }
}
