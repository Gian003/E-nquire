import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:enquire/services/auth_provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String otpCode = '';
  int _remainingTime = 30;
  bool _canResend = false;
  bool _isLoading = false;
  Timer? _timer;

  String? _selectedMethod;
  String _userEmail = '';
  String _userPhone = '';
  String _maskedContact = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  /// Get user contact info (email or phone) from ModalRoute arguments
  /// and auto-select the method to send verification code
  ///
  /// If email is not empty, it will be selected as the method
  /// and the masked email will be displayed
  /// If phone is not empty, it will be selected as the method
  /// and the masked phone will be displayed
  ///
  /// If a method is selected, it will call [_sendVerificationCode] to
  /// send a verification code to the selected contact info
  void _getUserContactInfo() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _userEmail = args['email'] ?? '';
      _userPhone = args['phone'] ?? '';

      //Auto-select email or phone
      if (_userEmail.isNotEmpty) {
        _selectedMethod = 'email';
        _maskedContact = _getMaskedEmail(_userEmail);
      } else if (_userPhone.isNotEmpty) {
        _userPhone = 'phone';
        _maskedContact = _getMaskedPhone(_userPhone);
      }

      if (_selectedMethod != null) {
        _sendVerificationCode();
      }
    }
  }

  /// This function takes an email address as a string and returns a masked version of it.
  ///
  /// The masked version is created by replacing all but the first two characters of the username with asterisks.
  ///
  /// For example, if the email address is "john.doe@example.com", the masked version would be "jo*****@example.com".
  ///
  /// If the email address is empty or the username has a length of two or less, the original email address is returned.
  String _getMaskedEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      // If the username has a length of two or less, return the original email address
      return email;
    }

    // Get the first two characters of the username
    final firstTwo = username.substring(0, 2);

    // Calculate the number of asterisks needed to replace the remaining characters of the username
    final stars = '*' * (username.length - 2);

    // Return the masked email address
    return '$firstTwo$stars@$domain';
  }

  /// This function takes a phone number as a string and returns a masked version of it.
  ///
  /// The masked version is created by replacing all but the last four characters of the phone number with asterisks.
  ///
  /// For example, if the phone number is "1234567890", the masked version would be "*****6789".
  ///
  /// If the phone number is empty or has a length of four or less, the original phone number is returned.
  String _getMaskedPhone(String phone) {
    if (phone.isEmpty) return '';
    if (phone.length <= 4) return phone;

    final lastFour = phone.substring(phone.length - 4);
    final stars = '*' * (phone.length - 4);
    return '$stars$lastFour';
  }

  /// Sends a verification code to the user's selected contact method (email or phone).
  ///
  /// If the user has selected an email, the verification code will be sent to the user's email address.
  /// If the user has selected a phone number, the verification code will be sent to the user's phone number.
  ///
  /// This function sets the [_isLoading] state to true, and then sets it back to false once the verification code has been sent or an error has occurred.
  ///
  /// If the verification code is sent successfully, a snackbar is shown to the user with a message indicating that the verification code has been sent to their selected contact method.
  ///
  /// If an error occurs while sending the verification code, a snackbar is shown to the user with a message indicating that the verification code could not be sent.
  ///
  /// This function also starts a countdown from 30 seconds, and sets the [_canResend] state to false during the countdown period.
  Future<void> _sendVerificationCode() async {
    if (_selectedMethod == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.sendVerificationCode(
        method: _selectedMethod!,
        email: _userEmail,
        phone: _userPhone,
      );

      setState(() {
        _isLoading = false;
        _canResend = false;
        _remainingTime = 30;
      });

      _startCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to your $_selectedMethod!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send verification code: $e')),
        );
      }
    }
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _remainingTime = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _verifyCode() async {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter the 6-digit code')));

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.verifyCode(
        code: otpCode,
        method: _selectedMethod!,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Verification successful')));
          Navigator.pushReplacementNamed(context, '/acount_creation');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invalid verification code')));
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
      }
    }
  }

  void _resendCode() {
    if (_canResend) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resending code...')));
      _sendVerificationCode();
      _startCountdown();
    }
  }

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
      _maskedContact = method == 'email'
          ? _getMaskedEmail(_userEmail)
          : _getMaskedPhone(_userPhone);
    });

    _sendVerificationCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

            const Text(
              'Verify Code',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            if (_userEmail.isNotEmpty &&
                _userPhone.isNotEmpty &&
                _selectedMethod == null) ...[
              const Text(
                'Please choose how you want to receive your verifiaction code: ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              //Email Option
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.email, color: Color(0xFF2F5899)),
                  title: Text(
                    'Send via Email',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _getMaskedEmail(_userEmail),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.green[600],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 15),
                  onTap: () => _selectMethod('email'),
                ),
              ),

              //Phone Option
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.phone, color: Color(0xFF2F5899)),
                  title: Text(
                    'Send via SMS',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _getMaskedPhone(_userPhone),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 15),
                  onTap: () => _selectMethod('phone'),
                ),
              ),

              const SizedBox(height: 30),
            ],

            if (_selectedMethod != null) ...[
              const SizedBox(height: 10),

              Text(
                'Please enter the 6-digit code we just sent to your $_selectedMethod',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              Text(
                _maskedContact,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF2F5899),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                showFieldAsBox: true,
                fieldHeight: 65,
                fillColor: Colors.white,
                filled: false,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(5),
                  right: Radius.circular(5),
                ),
                onCodeChanged: (value) {
                  // handle code change
                },
                onSubmit: (String verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                  _verifyCode();
                },
              ),

              const SizedBox(height: 30),

              //Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2F5899),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F5899),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              //Resend Code Section
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Didn\'t recieve the code?',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _canResend
                      ? GestureDetector(
                          onTap: () {
                            _resendCode();
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Text(
                          'Resend available in 00:${_remainingTime.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 20),

              //Change Method Section
              if (_userEmail.isNotEmpty && _userPhone.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedMethod = null;
                      otpCode = '';
                      _timer?.cancel();
                      _canResend = false;
                      _remainingTime = 30;
                    });
                  },
                  child: Text(
                    'Change Verification Method',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2F5899),
                    ),
                  ),
                ),
            ],

            //Loading state when auto-sending
            if (_isLoading && _selectedMethod != null) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text(
                'Sending Verification code...',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
