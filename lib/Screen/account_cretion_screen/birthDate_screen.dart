import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthDateScreen extends StatefulWidget {
  final ValueChanged<DateTime?> onDateChanged;

  const BirthDateScreen({Key? key, required this.onDateChanged})
    : super(key: key);

  @override
  _BirthDateScreenState createState() => _BirthDateScreenState();
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedMonth;
  int? _selectedDay;
  int? _selectedYear;

  List<int> get daysInMonth {
    if (_selectedMonth == null || _selectedYear == null) {
      return List.generate(31, (i) => i + 1);
    }

    final lastDay = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
    return List.generate(lastDay, (i) => i + 1);
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext contextt) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'When were you born?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'We\'re here to verify if you\'re now of legal age',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
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
                      'assets/images/Calendar.png',
                      width: 30,
                      height: 30,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        'It\'s required for legal compliance and account security',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //Date picker
              Row(
                children: [
                  //Month picker
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.horizontal(
                        //     left: Radius.circular(10),
                        //     right: Radius.circular(10),
                        //   ),
                        // ),
                      ),
                      initialValue: _selectedMonth,
                      items: List.generate(12, (i) => i + 1)
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                DateFormat.MMMM().format(DateTime(0, m)),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedMonth = value),
                      // validator: (value) =>
                      //     value == null ? 'Please select a month' : null,
                    ),
                  ),

                  const SizedBox(width: 10),

                  //Day picker
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Day',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.horizontal(
                        //     left: Radius.circular(10),
                        //     right: Radius.circular(10),
                        //   ),
                        // ),
                      ),
                      items: daysInMonth
                          .map(
                            (d) =>
                                DropdownMenuItem(value: d, child: Text('$d')),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedDay = value),
                      // validator: (value) =>
                      //     value == null ? 'Please select a day' : null,
                    ),
                  ),

                  const SizedBox(width: 10),

                  //Year picker
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Year',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.horizontal(
                        //     left: Radius.circular(10),
                        //     right: Radius.circular(10),
                        //   ),
                        // ),
                      ),
                      items: List.generate(100, (i) => DateTime.now().year - i)
                          .map(
                            (y) =>
                                DropdownMenuItem(value: y, child: Text('$y')),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedYear = value),
                      // validator: (value) =>
                      //     value == null ? 'Please select a year' : null,
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
