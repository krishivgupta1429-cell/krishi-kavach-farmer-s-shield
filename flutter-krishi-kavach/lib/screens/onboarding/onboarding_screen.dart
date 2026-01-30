import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';
import '../../l10n/l10n.dart';

/// Multi-step onboarding wizard for farmer profile setup
class OnboardingScreen extends StatefulWidget {
  final StorageService storageService;
  
  const OnboardingScreen({super.key, required this.storageService});
  
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  // Onboarding answers
  String? _selectedCrop;
  String? _selectedFarmSize;
  String? _selectedIrrigation;
  String? _selectedFrequency;
  
  // Crop search
  final _cropSearchController = TextEditingController();
  List<String> _filteredCrops = CommonCrops.crops;
  
  @override
  void dispose() {
    _cropSearchController.dispose();
    super.dispose();
  }
  
  void _filterCrops(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCrops = CommonCrops.crops;
      } else {
        _filteredCrops = CommonCrops.crops
            .where((crop) => crop.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedCrop != null;
      case 1:
        return _selectedFarmSize != null;
      case 2:
        return _selectedIrrigation != null;
      case 3:
        return _selectedFrequency != null;
      default:
        return false;
    }
  }
  
  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _completeOnboarding();
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  Future<void> _completeOnboarding() async {
    await widget.storageService.saveOnboardingData(
      primaryCrop: _selectedCrop!,
      farmSize: _selectedFarmSize!,
      irrigationType: _selectedIrrigation!,
      issueFrequency: _selectedFrequency!,
    );
    
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            _buildHeader(loc),
            
            // Step content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(loc),
              ),
            ),
            
            // Navigation buttons
            _buildNavigation(loc),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Step indicator text
          Text(
            '${loc.stepOf} ${_currentStep + 1} / $_totalSteps',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 8,
              backgroundColor: AppTheme.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Title
          Text(
            loc.tellUsAboutFarm,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Text(
            loc.helpUsServeYou,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepContent(AppLocalizations loc) {
    switch (_currentStep) {
      case 0:
        return _buildCropStep(loc);
      case 1:
        return _buildFarmSizeStep(loc);
      case 2:
        return _buildIrrigationStep(loc);
      case 3:
        return _buildFrequencyStep(loc);
      default:
        return const SizedBox();
    }
  }
  
  Widget _buildCropStep(AppLocalizations loc) {
    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.primaryCrop,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Search field
          TextField(
            controller: _cropSearchController,
            decoration: InputDecoration(
              hintText: loc.searchCrop,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _cropSearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _cropSearchController.clear();
                        _filterCrops('');
                      },
                    )
                  : null,
            ),
            onChanged: _filterCrops,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Crop list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCrops.length,
              itemBuilder: (context, index) {
                final crop = _filteredCrops[index];
                final isSelected = _selectedCrop == crop;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                  child: Material(
                    color: isSelected 
                        ? AppTheme.primaryGreen.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCrop = crop),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(
                            color: isSelected 
                                ? AppTheme.primaryGreen 
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected 
                                  ? Icons.check_circle_rounded 
                                  : Icons.eco_outlined,
                              color: isSelected 
                                  ? AppTheme.primaryGreen 
                                  : AppTheme.textMuted,
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: Text(
                                crop,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected 
                                      ? FontWeight.w600 
                                      : FontWeight.normal,
                                  color: isSelected 
                                      ? AppTheme.primaryGreen 
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFarmSizeStep(AppLocalizations loc) {
    final sizes = [
      {'key': 'small', 'label': loc.farmSmall, 'icon': Icons.grass_rounded},
      {'key': 'medium', 'label': loc.farmMedium, 'icon': Icons.landscape_rounded},
      {'key': 'large', 'label': loc.farmLarge, 'icon': Icons.terrain_rounded},
    ];
    
    return _buildOptionsList(
      key: const ValueKey(1),
      title: loc.farmSize,
      options: sizes,
      selectedValue: _selectedFarmSize,
      onSelect: (value) => setState(() => _selectedFarmSize = value),
    );
  }
  
  Widget _buildIrrigationStep(AppLocalizations loc) {
    final types = [
      {'key': 'rainfed', 'label': loc.irrigationRainfed, 'icon': Icons.water_drop_outlined},
      {'key': 'canal', 'label': loc.irrigationCanal, 'icon': Icons.waves_rounded},
      {'key': 'borewell', 'label': loc.irrigationBorewell, 'icon': Icons.engineering_rounded},
      {'key': 'drip', 'label': loc.irrigationDrip, 'icon': Icons.opacity_rounded},
      {'key': 'other', 'label': loc.irrigationOther, 'icon': Icons.more_horiz_rounded},
    ];
    
    return _buildOptionsList(
      key: const ValueKey(2),
      title: loc.irrigationType,
      options: types,
      selectedValue: _selectedIrrigation,
      onSelect: (value) => setState(() => _selectedIrrigation = value),
    );
  }
  
  Widget _buildFrequencyStep(AppLocalizations loc) {
    final frequencies = [
      {'key': 'rare', 'label': loc.frequencyRare, 'icon': Icons.sentiment_very_satisfied_rounded},
      {'key': 'sometimes', 'label': loc.frequencySometimes, 'icon': Icons.sentiment_neutral_rounded},
      {'key': 'often', 'label': loc.frequencyOften, 'icon': Icons.sentiment_dissatisfied_rounded},
    ];
    
    return _buildOptionsList(
      key: const ValueKey(3),
      title: loc.issueFrequency,
      options: frequencies,
      selectedValue: _selectedFrequency,
      onSelect: (value) => setState(() => _selectedFrequency = value),
    );
  }
  
  Widget _buildOptionsList({
    required Key key,
    required String title,
    required List<Map<String, dynamic>> options,
    required String? selectedValue,
    required Function(String) onSelect,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedValue == option['key'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  child: Material(
                    color: isSelected 
                        ? AppTheme.primaryGreen.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    child: InkWell(
                      onTap: () => onSelect(option['key'] as String),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          border: Border.all(
                            color: isSelected 
                                ? AppTheme.primaryGreen 
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppTheme.primaryGreen 
                                    : AppTheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                              child: Icon(
                                option['icon'] as IconData,
                                color: isSelected 
                                    ? Colors.white 
                                    : AppTheme.textMuted,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: Text(
                                option['label'] as String,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelected 
                                      ? FontWeight.w600 
                                      : FontWeight.normal,
                                  color: isSelected 
                                      ? AppTheme.primaryGreen 
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppTheme.primaryGreen,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigation(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            Expanded(
              child: PrimaryButton(
                label: loc.back,
                onPressed: _previousStep,
                isOutlined: true,
              ),
            ),
          
          if (_currentStep > 0)
            const SizedBox(width: AppTheme.spacingM),
          
          // Next/Complete button
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: PrimaryButton(
              label: _currentStep == _totalSteps - 1 
                  ? loc.startUsingApp 
                  : loc.next,
              onPressed: _canProceed ? _nextStep : null,
            ),
          ),
        ],
      ),
    );
  }
}
