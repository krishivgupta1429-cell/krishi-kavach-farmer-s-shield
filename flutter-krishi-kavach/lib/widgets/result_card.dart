import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/prediction_result.dart';
import '../l10n/l10n.dart';

/// Card displaying the prediction result with crop, disease, confidence, and remedies
class ResultCard extends StatelessWidget {
  final PredictionResult result;
  final bool showImage;
  final bool isCompact;
  
  const ResultCard({
    super.key,
    required this.result,
    this.showImage = true,
    this.isCompact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (isCompact) {
      return _buildCompactCard(context, loc);
    }
    
    return _buildFullCard(context, loc);
  }
  
  Widget _buildFullCard(BuildContext context, AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          if (showImage && result.imagePath != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLarge),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(
                  File(result.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfaceVariant,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Healthy badge or disease status
                if (result.isHealthy)
                  _buildHealthyBadge(loc)
                else
                  _buildDiseaseBadge(),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // Crop name
                _buildInfoRow(
                  icon: Icons.eco_outlined,
                  label: loc.crop,
                  value: result.crop,
                  color: AppTheme.primaryGreen,
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                // Disease name
                _buildInfoRow(
                  icon: result.isHealthy 
                      ? Icons.check_circle_outline 
                      : Icons.warning_amber_outlined,
                  label: loc.disease,
                  value: result.isHealthy ? loc.healthy : result.disease,
                  color: result.isHealthy ? AppTheme.success : AppTheme.warning,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // Confidence bar
                _buildConfidenceBar(loc),
                
                // Remedies section (if not healthy)
                if (!result.isHealthy && result.remedies.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacingL),
                  _buildRemediesSection(loc),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompactCard(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Thumbnail
          if (result.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.file(
                  File(result.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfaceVariant,
                    child: const Icon(Icons.eco, color: AppTheme.textMuted),
                  ),
                ),
              ),
            ),
          
          const SizedBox(width: AppTheme.spacingM),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.crop,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.isHealthy ? loc.healthy : result.disease,
                  style: TextStyle(
                    color: result.isHealthy ? AppTheme.success : AppTheme.warning,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Confidence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusRound),
            ),
            child: Text(
              result.confidencePercent,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHealthyBadge(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.success,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            loc.healthyMessage,
            style: const TextStyle(
              color: AppTheme.success,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiseaseBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.warning,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            result.disease,
            style: const TextStyle(
              color: AppTheme.warning,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  
  Widget _buildConfidenceBar(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.confidence,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
            Text(
              result.confidencePercent,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          child: LinearProgressIndicator(
            value: result.confidence,
            minHeight: 10,
            backgroundColor: AppTheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getConfidenceColor(result.confidence),
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppTheme.success;
    if (confidence >= 0.5) return AppTheme.warning;
    return AppTheme.error;
  }
  
  Widget _buildRemediesSection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.medical_services_outlined,
              color: AppTheme.primaryGreen,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              loc.remedies,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...result.remedies.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
