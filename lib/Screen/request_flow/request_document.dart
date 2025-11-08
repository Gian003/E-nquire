import 'dart:io';
import 'package:enquire/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class RequestDocument extends StatefulWidget {
  const RequestDocument({super.key});

  @override
  State<RequestDocument> createState() => _RequestDocumentState();
}

class _RequestDocumentState extends State<RequestDocument>
    with TickerProviderStateMixin {
  //Request Dropdown
  String? _selectedRequest;
  final List<String> _requestOptions = [
    'Residency Certificate',
    'Barangay Clearance',
    'Business Permit',
    'Indigency Certificate',
    'CENOMAR',
    'Birth Certificate',
    'Marriage Certificate',
    'Death Certificate',
    'Other Documents',
  ];

  //Payment Method Dropdown
  String? _selectPayment;
  final List<String> _paymentOptions = ['None', 'Donate'];

  //Purpose of Request Text Controller
  final TextEditingController _purposeController = TextEditingController();

  //Image Picker
  XFile? _selectedImage;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  //Animation controller
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    _animationAfterSubmit();
  }

  Future<void> _animationAfterSubmit() async {
    MainAxisAlignment.center;
    _animationController.reset();

    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _animationController.removeStatusListener(statusListener);
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }

    _animationController.addStatusListener(statusListener);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 350,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/submit_animation.json',
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController
                      ..duration = composition.duration
                      ..forward();
                  },
                  repeat: false,
                  fit: BoxFit.contain,
                ),

                Text(
                  'Request Submitted!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F5899),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  SizedBox(width: 35),

                  Text(
                    'Request Document',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 65),

              Column(
                children: [
                  //Request Form
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select your Request',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      DropdownButtonFormField(
                        initialValue: _selectedRequest,
                        decoration: InputDecoration(
                          hintText: 'Choose your Document',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        items: _requestOptions
                            .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRequest = value;
                            if (value != null) {
                              print('Selected Request: $value');
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //Payment Method
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      DropdownButtonFormField(
                        initialValue: _selectPayment,
                        decoration: InputDecoration(
                          hintText: 'Choose Payment Method',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        items: _paymentOptions
                            .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectPayment = value;
                            if (value != null) {
                              print('Selected Payment Method: $value');
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //Purpose of Request
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Purpose of Request',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextField(
                        controller: _purposeController,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'Enter the purpose of your request',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //Image Upload Widget
                  _selectedImage == null
                      ? ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2F5899),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 30),

                              const SizedBox(width: 15),

                              Text(
                                'Upload Valid ID',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Image.file(File(_selectedImage!.path)),

                            const SizedBox(height: 5),

                            ElevatedButton(
                              onPressed: _removeImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
                                'Remove Image',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),

      //Sumbit Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F5899),
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
              'Submit',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
