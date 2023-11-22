import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ssc/firebase_options.dart';
import 'package:ssc/screens/home_screen.dart';
import 'package:ssc/screens/signin_screen.dart';
import 'package:ssc/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillExchangePlatform',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      // home: const HomeScreen(),
    );
  }
}
