import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssc/screens/reusable.dart';
import 'package:ssc/utils/color_utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.amber,
        elevation: 0,
        title: const Text(
          "Reset Password",
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
                      "Enter Email Id",
                      Icons.person_outline,
                      false,
                      _emailTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "Reset Password", () {
                      _resetPassword();
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

  void _resetPassword() {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailTextController.text)
        .then((value) {
      // Reset email sent successfully
      Navigator.of(context).pop();
    }).catchError((error) {
      print("Error ${error.toString()}");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
