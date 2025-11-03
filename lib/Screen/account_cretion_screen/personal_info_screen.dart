import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController? genderController;

  const PersonalInfoScreen({
    Key? key,
    required this.formkey,
    required this.firstNameController,
    required this.lastNameController,
    required this.genderController,
  }) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // List of gender options
  final List<String> _genderList = [
    'Male',
    'Female',
    'Non-Binary',
    'Other',
    'Prefer not to say',
  ];

  // Stores the gender selected by the user
  String? _selectedGender;

  // Stores the gender text field controller
  late final TextEditingController _genderController;
  late final bool _ownsGenderController;

  @override
  void initState() {
    super.initState();
    // Initialize the gender text field controller
    if (widget.genderController == null) {
      _genderController = TextEditingController();
      _ownsGenderController = true;
    } else {
      _genderController = widget.genderController!;
      _ownsGenderController = false;
    }
  }

  @override
  void dispose() {
    if (_ownsGenderController) {
      _genderController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: widget.formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Let\'s get you started',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      'What\'s your full name?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'We need to know your full name as it is exactly as it appears on your ID.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(5),
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
                        'assets/images/Security Lock.png',
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'Your Information is safe and secure',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF2F5899),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Name Fields
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: widget.firstNameController,
                            decoration: InputDecoration(
                              hintText: 'First Name',
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
                            //     return 'Please enter your first name';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: TextFormField(
                            controller: widget.lastNameController,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
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
                            //     return 'Please enter your last name';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Gender Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Gender',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10),
                        right: Radius.circular(10),
                      ),
                    ),
                  ),
                  items: _genderList
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      if (value != 'Other') {
                        _genderController.text = '';
                      }
                    });
                  },
                  // validator: (value) {
                  //   return null;
                  // },
                ),

                const SizedBox(height: 5),

                if (_selectedGender == 'Other')
                  TextFormField(
                    controller: _genderController,
                    decoration: InputDecoration(
                      labelText: 'Please Specify',
                      border: OutlineInputBorder(),
                    ),
                    // validator: (value) {
                    //   if (_selectedGender == 'Other' &&
                    //       (value == null || value.trim().isEmpty)) {
                    //     return 'Please provide your Gender';
                    //   }
                    //   return null;
                    // },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
