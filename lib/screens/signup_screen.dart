import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssc/screens/home_screen.dart';
import 'package:ssc/screens/reusable.dart';
import 'package:ssc/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  bool _isLoading = false;

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        foregroundColor: Colors.amber,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexStringToColor("22223b"),
                  hexStringToColor("22223b"),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter UserName",
                      Icons.person_outline,
                      false,
                      _userNameTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter Email Id",
                      Icons.person_outline,
                      false,
                      _emailTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter Password",
                      Icons.lock_outlined,
                      false,
                      _passwordTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "Sign Up", () {
                      _signUp();
                    }),
                  ],
                ),
              ),
            ),
          ),
          _isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: hexStringToColor("ffffff"),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });

      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({'username': _userNameTextController.text, 'bio': "Nothing"});
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    )
        .then((value) {
      print("Created New Account");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }).catchError((error) {
      print("Error ${error.toString()}");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
