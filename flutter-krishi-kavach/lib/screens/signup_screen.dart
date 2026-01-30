import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/primary_button.dart';
import '../widgets/language_toggle.dart';
import '../l10n/l10n.dart';

/// Signup screen - full registration form
class SignupScreen extends StatefulWidget {
  final StorageService storageService;
  
  const SignupScreen({super.key, required this.storageService});
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _districtController = TextEditingController();
  
  String? _selectedState;
  String _selectedLanguage = 'en';
  bool _acceptedTerms = false;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _districtController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Validators.validateTermsAccepted(false) ?? ''),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await widget.storageService.saveSignupData(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        state: _selectedState!,
        district: _districtController.text.trim().isNotEmpty 
            ? _districtController.text.trim() 
            : null,
        language: _selectedLanguage,
      );
      
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/onboarding');
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).apiError),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  loc.signup,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // Full name
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: loc.fullName,
                    hintText: loc.enterName,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // Mobile number
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: loc.mobileNumber,
                    hintText: loc.enterMobile,
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    prefixText: '+91 ',
                    counterText: '',
                  ),
                  validator: Validators.validateMobile,
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // State dropdown
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: InputDecoration(
                    labelText: loc.selectState,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  items: IndianStates.states.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedState = value);
                  },
                  validator: (value) => Validators.validateState(value),
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // District (optional)
                TextFormField(
                  controller: _districtController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: loc.district,
                    hintText: loc.enterDistrict,
                    prefixIcon: const Icon(Icons.location_city_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Language preference
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.preferredLanguage,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      LanguageToggle(showLabel: false),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Terms checkbox
                CheckboxListTile(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() => _acceptedTerms = value ?? false);
                  },
                  title: Text(
                    loc.acceptTerms,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppTheme.primaryGreen,
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // Create account button
                PrimaryButton(
                  label: loc.createAccount,
                  onPressed: _handleSignup,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(loc.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
