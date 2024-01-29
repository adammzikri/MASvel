// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:masvel/screens/auth/login.dart';
import 'package:masvel/screens/bottom_bar.dart';
import 'package:masvel/screens/home_screens.dart';
import 'package:masvel/screens/user.dart';
import 'package:masvel/widgets/reusable_widget.dart';

import '../../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  bool error = false;

  bool passwordConfirmed() {
    if (_passwordTextController.text == _confirmpasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  Future addUserDetails(String email, String username) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': username,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("4B6CB7"),
          hexStringToColor("182848"),
          //hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Confirm Password", Icons.lock_outline, true,
                    _confirmpasswordController),
                const SizedBox(
                  height: 20,
                ),
                error == true ? Text("password does not match") : Container(),
                logInSignUpButton(context, false, () {
                  if (passwordConfirmed()) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text.trim())
                        .then((value) {
                      addUserDetails(
                        _emailTextController.text.trim(),
                        _userNameTextController.text.trim(),
                      );
                      print("Created New Account");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  } else {
                    setState(() {
                      error = true;
                    });
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
