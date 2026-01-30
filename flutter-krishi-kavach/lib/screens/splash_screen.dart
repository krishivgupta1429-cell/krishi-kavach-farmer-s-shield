import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

/// Splash screen with app branding and auth state check
/// Routes to appropriate screen based on login/onboarding status
class SplashScreen extends StatefulWidget {
  final StorageService storageService;
  
  const SplashScreen({super.key, required this.storageService});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    
    _controller.forward();
    _navigateToNextScreen();
  }
  
  Future<void> _navigateToNextScreen() async {
    // Wait for animation + minimum splash duration
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;
    
    final isLoggedIn = widget.storageService.isLoggedIn();
    final isOnboardingComplete = widget.storageService.isOnboardingComplete();
    
    String route;
    if (!isLoggedIn) {
      route = '/login';
    } else if (!isOnboardingComplete) {
      route = '/onboarding';
    } else {
      route = '/home';
    }
    
    Navigator.of(context).pushReplacementNamed(route);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.heroGradient,
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      size: 60,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // App name
                  const Text(
                    'Krishi Kavach',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Hindi name
                  const Text(
                    'कृषि कवच',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Loading indicator
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
