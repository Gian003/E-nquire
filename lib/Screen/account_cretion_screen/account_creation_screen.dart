import 'package:flutter/material.dart';

import 'personal_info_screen.dart';

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({Key? key}) : super(key: key);

  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  final PageController _pageController = PageController();

  int _currentStep = 0;

  //Controllers for Personal Info inputs
  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final bool _ownsGenderController = false;

  List<Widget> get _rawPages => [
    PersonalInfoScreen(
      formkey: _formkey,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      genderController: _genderController,
      ownsGenderController: _ownsGenderController,
    ),
  ];

  Widget _wrapPage(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewPortHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewPortHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }

  List<Widget> get _pages => _rawPages.map((w) => _wrapPage(w)).toList();

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final lastIndex = _pages.length - 1;
    if (_currentStep == 0) {
      if (!(_formkey.currentState?.validate() ?? false)) {
        return;
      }
      _formkey.currentState?.save();
    }

    if (_currentStep < lastIndex) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _confirmRegistrtion() {
    //Sends to DB later
    debugPrint(
      'Registered: ${_firstNameController.text} ${_lastNameController.text}',
    );
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final lastIndex = _pages.length - 1;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentStep = index);
        },
        children: _pages,
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          backgroundColor: Color(0xFF2F5899),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  if (_currentStep > 0 && _currentStep <= lastIndex)
                    const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep == lastIndex) {
                          _confirmRegistrtion();
                        } else {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: Color(0xFF2F5899),
                      ),
                      child: Text(
                        _currentStep == lastIndex ? 'Finish' : 'Next',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  const SizedBox(width: 5),

                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),

                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
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
    );
  }
}
