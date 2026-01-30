import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/prediction_result.dart';
import '../widgets/result_card.dart';
import '../widgets/primary_button.dart';
import '../l10n/l10n.dart';

/// Result screen displaying prediction details
class ResultScreen extends StatelessWidget {
  final StorageService storageService;
  final Map<String, dynamic>? result;
  
  const ResultScreen({
    super.key,
    required this.storageService,
    this.result,
  });
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (result == null) {
      return _buildErrorState(context, loc);
    }
    
    final prediction = PredictionResult.fromJson(result!);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(loc.result),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result card
              ResultCard(result: prediction),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: AppTheme.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        loc.disclaimer,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.info,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // Action buttons
              PrimaryButton(
                label: loc.scanAnother,
                icon: Icons.camera_alt_rounded,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: loc.saveResult,
                      icon: Icons.save_outlined,
                      isOutlined: true,
                      onPressed: () => _saveResult(context, loc, prediction),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: PrimaryButton(
                      label: loc.share,
                      icon: Icons.share_outlined,
                      isOutlined: true,
                      onPressed: () {
                        // Share functionality stub
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context, AppLocalizations loc) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(loc.result),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppTheme.error,
              ),
              const SizedBox(height: AppTheme.spacingL),
              Text(
                loc.error,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                loc.apiError,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              PrimaryButton(
                label: loc.retry,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _saveResult(
    BuildContext context,
    AppLocalizations loc,
    PredictionResult prediction,
  ) async {
    await storageService.addToScanHistory(prediction);
    
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(loc.resultSaved),
          ],
        ),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}
