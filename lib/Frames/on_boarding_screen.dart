import 'package:enquire/main.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<Widget> _screens = [Screen1(), Screen2(), Screen3()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _screens,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _screens.map((screen) {
              int index = _screens.indexOf(screen);
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: index == _currentIndex ? 4.0 : 8.0,
                ),
                width: 8.0,
                height: index == _currentIndex ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentIndex ? Colors.blue : Colors.grey,
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_currentIndex > 0) {
                      _currentIndex--;
                    }
                  });
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.blue),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_currentIndex < _screens.length - 1) {
                      _currentIndex++;
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    }
                  });
                },
                child: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
