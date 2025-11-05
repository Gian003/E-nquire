import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 75, height: 75),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Welcome,',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Column(
              //   children: [
              //     SizedBox(
              //       width: 325,
              //       height: 110,
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.horizontal(
              //               left: Radius.circular(10),
              //               right: Radius.circular(10),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {},
              //         child: Row(
              //           children: [
              //             Image.asset(
              //               'assets/images/notificationpng',
              //               height: 40,
              //               width: 40,
              //             ),

              //             const SizedBox(width: 35),

              //             Text(
              //               'Notifications',
              //               style: TextStyle(
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                width: 325,
                height: 110,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/notification.png',
                            height: 40,
                            width: 40,
                          ),

                          const SizedBox(width: 20),

                          Text(
                            'Schedule',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
