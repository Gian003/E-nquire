import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enquire/Screen/register_screen.dart';

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
        initialRoute: '/register',
        routes: {
          // '/': (context) => SplashScreenWrapper(),
          // '/onboarding': (context) => OnBoardingScreen(),
          // '/home': (context) => MyHomePage(),
          // '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
