import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController provinceController;
  final TextEditingController zipCodeController;
  final TextEditingController countryController;

  const AddressScreen({
    Key? key,
    required this.formKey,
    required this.streetController,
    required this.cityController,
    required this.provinceController,
    required this.zipCodeController,
    required this.countryController,
  }) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'What\'s your address?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      'We need current residential address for account access and secure communication',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 237, 255),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: const Color.fromARGB(255, 200, 218, 254),
                            width: 1,
                          ),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Address.png',
                            width: 30,
                            height: 30,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Your address will be verified against official records',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF2F5899),
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Column(
                      children: [
                        //Street input
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Street',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              controller: widget.streetController,
                              decoration: InputDecoration(
                                hintText: 'Ex: 123 Main Street',
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                    right: Radius.circular(10),
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   if (value == null || value.trim().isEmpty) {
                              //     return 'Please enter your street';
                              //   }
                              //   return null;
                              // },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            //City input
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'City',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: widget.cityController,
                                    decoration: InputDecoration(
                                      hintText: 'Ex: New York',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null ||
                                    //       value.trim().isEmpty) {
                                    //     return 'Please enter your city';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            //Province input
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Province',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: widget.provinceController,
                                    decoration: InputDecoration(
                                      hintText: 'Ex: Pangasinan',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null ||
                                    //       value.trim().isEmpty) {
                                    //     return 'Please enter your province';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            //Zip Code input
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Zip Code',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: widget.provinceController,
                                    decoration: InputDecoration(
                                      hintText: 'Ex: 1234',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null ||
                                    //       value.trim().isEmpty) {
                                    //     return 'Please enter your zip code';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            //Country input
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Country',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: widget.provinceController,
                                    decoration: InputDecoration(
                                      hintText: 'Ex: Philippines',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null ||
                                    //       value.trim().isEmpty) {
                                    //     return 'Please enter your country';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
