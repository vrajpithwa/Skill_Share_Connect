import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/screens/signin_screen.dart';
import 'package:ssc/utils/color_utils.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> listPagesViewModel = [
      introPageModel(
          "'Welcome to Skill Share Connect'",
          "Unlock Your Potential, Connect with Skills",
          "Skill Share Connect is your gateway to a world of learning and collaboration. Whether you're looking to enhance your skills or share your expertise, we've got you covered.",
          "assets/images/logo2.png",
          hexStringToColor("134074")),
      introPageModel(
          "'Discover and Connect'",
          "Find, Learn, and Connect with Like-minded Individuals",
          "Explore a diverse range of skills, courses, and experts. Connect with passionate individuals who share your interests. Skill Share Connect is more than just an app; it's a community where knowledge knows no bounds.",
          "assets/images/share.png",
          hexStringToColor("0b2545")),
      introPageModel(
          "'Seamless Learning Experience'",
          "Showcase a user engaging with the app on different devices",
          "With Skill Share Connect, your learning journey is flexible. Access courses and connect with mentors anytime, anywhere. Take your skills to new heights with our user-friendly platform designed to fit your lifestyle.",
          "assets/images/intro3.png",
          hexStringToColor("6290c8")),
    ];

    return Scaffold(
      body: IntroductionScreen(
        pages: listPagesViewModel,
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        next: const Icon(
          Icons.arrow_forward,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        done: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        onDone: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('firstTime', false);
// ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        },
        onSkip: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('firstTime', false);
// ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        },
        controlsPadding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10),
          activeSize: const Size(20, 20),
          activeColor: hexStringToColor("d90368"),
          color: Colors.grey[300]!,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  introPageModel(
    String title,
    String bodyText,
    String extraDescription,
    String imgPath,
    Color backColor,
  ) {
    return PageViewModel(
      title: title,
      body: bodyText,
      image: Image.asset(
        imgPath,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width * 0.5,
        height: 500,
      ),
      reverse: true,
      decoration: PageDecoration(
        pageMargin: const EdgeInsets.all(0),
        titlePadding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
        bodyPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        imagePadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        pageColor: backColor,
        titleTextStyle: const TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      // New extra description parameter
      footer: Container(
        padding: const EdgeInsets.fromLTRB(
            30, 60, 10, 10), // Adjust the padding as needed
        child: Text(
          extraDescription,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
