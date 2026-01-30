import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../utils/validators.dart';
import '../widgets/primary_button.dart';
import '../l10n/l10n.dart';

/// Login screen - mobile number entry point
class LoginScreen extends StatefulWidget {
  final StorageService storageService;
  
  const LoginScreen({super.key, required this.storageService});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Simulate a brief delay for UX
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if user exists (in real app, verify with backend)
    // For now, if mobile exists in storage, log them in
    final savedMobile = widget.storageService.getUserMobile();
    
    if (savedMobile == _mobileController.text.trim()) {
      await widget.storageService.setLoggedIn(true);
      
      if (!mounted) return;
      
      if (widget.storageService.isOnboardingComplete()) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    } else {
      // User not found, go to signup
      if (!mounted) return;
      Navigator.of(context).pushNamed('/signup');
    }
    
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacingXXL),
                
                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: AppTheme.buttonShadow,
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // App name
                Text(
                  loc.appName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXXL),
                
                // Welcome message
                Text(
                  loc.welcomeBack,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                Text(
                  loc.enterMobileToLogin,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // Mobile number input
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
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // Continue button
                PrimaryButton(
                  label: loc.continueBtn,
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(loc.signup),
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
