import 'package:flutter/material.dart';
import 'package:ssc/screens/introscreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// Delay for 5 seconds before navigating to the main screen
    Future.delayed(Duration(seconds: 5), () {
// Navigate to the main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroductionPage(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
// Your PNG image goes here
            Image.asset(
              'assets/images/splashscreen.gif', // Replace with your image path
              width: 500, // Adjust the width as needed
              // Adjust the height as needed
            ),
          ],
        ),
      ),
    );
  }
}
