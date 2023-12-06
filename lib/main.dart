import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ssc/api/firebase_api.dart';
import 'package:ssc/firebase_options.dart';
import 'package:ssc/screens/home_screen.dart';
import 'package:ssc/screens/signin_screen.dart';
import 'package:ssc/screens/splash_screen.dart';
import 'package:ssc/theme/darkTheme.dart';
import 'package:ssc/theme/lightTheme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51OK3kCSCjcltMaRXn3s1MHJetoFcRKlL72pFDiBDZtlaemMx2WFBnE5wFJ3sbvRHt0fRheK9mK7eHOnEMERNiBss006rhAdfkO";
  // await Stripe.instance.applySettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillExchangePlatform',
      theme: lightTheme,
      darkTheme: darkTheme,
        home: SplashScreen(),
      // home: HomeScreen(),
      // home: SignInScreen(),
    );
  }
}