import 'package:enquire/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final String emailTest = "test@example.com";
  final String passwordTest = "12345678";
  final String confirmPasswordTest = "12345678";

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneContrroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password Variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneContrroller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //Validation Functions
  bool _isEmailValid(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  bool _isPhoneValid(String value) {
    final phoneRegex = RegExp(r'^\d{7,15}$');
    return phoneRegex.hasMatch(value);
  }

  bool _isPasswordValid(String value) {
    return value.length >= 8;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      //Prepare registration data
      final userData = {
        'email': _emailController.text.trim(),
        'phone': _phoneContrroller.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      };

      await authProvider.register(userData);

      if (authProvider.isAuthenticated) {
        //Success - Navigate to Home Screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/account_creation');
        }
      } else {
        print('Registration failed: ${authProvider.error}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),

                  // Logo and App Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 75,
                        height: 75,
                      ),
                      const SizedBox(width: 10),

                      const Text(
                        'E-nquire',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Register title
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  //Error message display
                  if (authProvider.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              authProvider.error!,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone number';
                          }

                          if (_isEmailValid(value)) {
                            return null;
                          }

                          return 'Please enter a valid email address';
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _phoneContrroller,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }

                          if (_isPhoneValid(value)) {
                            return null;
                          }

                          return 'Please enter a valid Phone number';
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: _obscurePassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          if (!_isPasswordValid(value)) {
                            return 'Password must be at least 8 characters';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Confirm Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: _obscureConfirmPassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Register Button
                  authProvider.isLoading
                      ? SizedBox(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2F5899),
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2F5899),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                  const SizedBox(height: 20),

                  //Login Redirect Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Alrready have an Account?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      const SizedBox(width: 5),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },

                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2F5899),
                          ),
                        ),
                      ),
                    ],
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
