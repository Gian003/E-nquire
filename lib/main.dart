import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:enquire/Screen/splash_screen.dart';
// import 'package:enquire/Screen/on_boarding_screen.dart';
// import 'package:enquire/Screen/login_screen.dart';
// import 'package:enquire/Screen/register_screen.dart';
import 'package:enquire/Screen/verify_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'E-nquire',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(47, 88, 153, 100),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/verify',
        routes: {
          // '/': (context) => SplashScreenWrapper(),
          // '/onboarding': (context) => OnBoardingScreen(),
          // '/home': (context) => MyHomePage(),
          // '/login': (context) => LoginScreen(),
          // '/register': (context) => RegisterScreen(),
          '/verify': (context) => VerifyScreen(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
