import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../widgets/language_toggle.dart';
import '../widgets/primary_button.dart';
import '../widgets/result_card.dart';
import '../l10n/l10n.dart';

/// Profile screen with user info, history, and logout
class ProfileScreen extends StatefulWidget {
  final StorageService storageService;
  
  const ProfileScreen({super.key, required this.storageService});
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(loc.profile),
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
              // Profile card
              _buildProfileCard(context, loc),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Farm info card
              _buildFarmInfoCard(context, loc),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Scan history
              _buildHistorySection(context, loc),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // Logout button
              PrimaryButton(
                label: loc.logout,
                icon: Icons.logout_rounded,
                isOutlined: true,
                onPressed: () => _showLogoutConfirmation(context, loc),
              ),
              
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileCard(BuildContext context, AppLocalizations loc) {
    final name = widget.storageService.getUserName();
    final mobile = widget.storageService.getUserMobile();
    final state = widget.storageService.getUserState();
    final district = widget.storageService.getUserDistrict();
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Name
          Text(
            name.isNotEmpty ? name : 'Farmer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          // Mobile
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_android_rounded,
                size: 16,
                color: AppTheme.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                '+91 $mobile',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          // Location
          if (state.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  district.isNotEmpty ? '$district, $state' : state,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildFarmInfoCard(BuildContext context, AppLocalizations loc) {
    final crop = widget.storageService.getPrimaryCrop();
    final farmSize = widget.storageService.getFarmSize();
    final irrigation = widget.storageService.getIrrigationType();
    
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
                Icons.agriculture_rounded,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Farm Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          _buildInfoRow(
            context,
            icon: Icons.eco_rounded,
            label: loc.crop,
            value: crop,
          ),
          
          _buildInfoRow(
            context,
            icon: Icons.landscape_rounded,
            label: 'Farm Size',
            value: _getFarmSizeLabel(farmSize, loc),
          ),
          
          _buildInfoRow(
            context,
            icon: Icons.water_drop_outlined,
            label: 'Irrigation',
            value: _getIrrigationLabel(irrigation, loc),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistorySection(BuildContext context, AppLocalizations loc) {
    final history = widget.storageService.getScanHistory();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.scanHistory,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (history.isNotEmpty)
              TextButton(
                onPressed: () => _showClearHistoryConfirmation(context, loc),
                child: Text(
                  loc.clearHistory,
                  style: const TextStyle(color: AppTheme.error),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        if (history.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    loc.noHistoryYet,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length > 5 ? 5 : history.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                child: ResultCard(
                  result: history[index],
                  isCompact: true,
                ),
              );
            },
          ),
      ],
    );
  }
  
  String _getFarmSizeLabel(String key, AppLocalizations loc) {
    switch (key) {
      case 'small':
        return loc.farmSmall;
      case 'medium':
        return loc.farmMedium;
      case 'large':
        return loc.farmLarge;
      default:
        return key;
    }
  }
  
  String _getIrrigationLabel(String key, AppLocalizations loc) {
    switch (key) {
      case 'rainfed':
        return loc.irrigationRainfed;
      case 'canal':
        return loc.irrigationCanal;
      case 'borewell':
        return loc.irrigationBorewell;
      case 'drip':
        return loc.irrigationDrip;
      case 'other':
        return loc.irrigationOther;
      default:
        return key;
    }
  }
  
  void _showLogoutConfirmation(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.logout),
        content: Text(loc.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.storageService.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text(
              loc.logout,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showClearHistoryConfirmation(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.clearHistory),
        content: const Text('Are you sure you want to clear all scan history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.storageService.clearScanHistory();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text(
              loc.clearHistory,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
