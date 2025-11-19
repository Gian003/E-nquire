import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enquire/Screen/splash_screen.dart';
import 'package:enquire/Screen/on_boarding_screen.dart';
import 'package:enquire/Screen/login_screen.dart';
import 'package:enquire/Screen/register_screen.dart';
import 'package:enquire/Screen/verify_screen.dart';
import 'package:enquire/Screen/account_cretion_screen/account_creation_screen.dart';
import 'package:enquire/Screen/home_screen.dart';
import 'package:enquire/Screen/request_flow/request_document.dart';

import 'package:enquire/services/api_service.dart';
import 'package:enquire/services/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider(create: (context) => ApiService()),
      ],
      child: MaterialApp(
        title: 'E-nquire',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(47, 88, 153, 100),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreenWrapper(),
          '/onboarding': (context) => OnBoardingScreen(),
          '/home': (context) => MyHomePage(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/verify': (context) => VerifyScreen(),
          '/account_creation': (context) => AccountCreationScreen(),
          '/request_document': (context) => RequestDocument(),
        },
      ),
    );
  }
}
