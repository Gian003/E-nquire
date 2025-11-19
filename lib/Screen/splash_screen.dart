import 'package:enquire/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatefulWidget {
  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  Future<void> _initializApp() async {
    //Check Authentication Status
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthentication();

      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        _navigateBasedonAuth(authProvider);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize app: $e';
        });
      }
    }
  }

  void _navigateBasedonAuth(AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _initializApp();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      hasError: _hasError,
      errorMessage: _errorMessage,
      onRetry: _retryInitialization,
    );
  }
}

class SplashScreen extends StatelessWidget {
  final bool hasError;
  final String errorMessage;
  final VoidCallback? onRetry;

  const SplashScreen({
    super.key,
    this.hasError = false,
    this.errorMessage = '',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),

              SizedBox(height: 30),

              if (hasError) ..._buildErrorState() else ..._buildLoadingState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.9 + (value * 0.1), //Subtle Scale Effect
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              filterQuality: FilterQuality.high,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLoadingState() {
    return [
      //Smooth Loading indicator
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 2000),
        builder: (context, value, child) {
          return SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              backgroundColor: Colors.grey[300],
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _buildErrorState() {
    return [
      Icon(Icons.error_outline, size: 50, color: Colors.red),
      SizedBox(height: 15),
      Text(
        'Oops',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      SizedBox(height: 10),
      Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: onRetry,
        icon: Icon(Icons.refresh),
        label: Text(
          'Try again',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2F5899),
          foregroundColor: Colors.white,
        ),
      ),
    ];
  }
}
