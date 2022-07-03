// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spacecapade/screens/register.dart';
import 'package:spacecapade/screens/scores.dart';

import 'mainmenu.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = 'redacted';
    String password = 'redacted';

    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(
          onChanged: (value) {
            email = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter E-mail', icon: Icon(Icons.email)),
        ),
        TextField(
          obscureText: true,
          obscuringCharacter: '*',
          onChanged: (value) {
            password = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter Password', icon: Icon(Icons.lock)),
        ),
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 2, //set size to 1/2 of scren
          child: ElevatedButton(
              onPressed: () async {
                String? errorCode;
                try {
                  await auth.signInWithEmailAndPassword(
                      email: email.trim(), password: password.trim());
                } on FirebaseAuthException catch (e) {
                  errorCode = e.code;
                }
                if (errorCode == null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Scores()));
                } else if (errorCode == 'wrong-password') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Password Incorrect"),
                          content: Text(
                              "Ensure that the password you entered is correct"),
                        );
                      });
                } else if (errorCode == 'user-not-found') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Account doesn't exist"),
                          content: Text(
                              "No user corresponding to the given email. Consider Registering."),
                        );
                      });
                }
              },
              child: Text("Log In")),
        ),
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 2, //set size to 1/2 of screen
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Register()));
              },
              child: Text("Register")),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainMenu()));
              },
              child: const Icon(Icons.arrow_back_ios_new),
            )),
      ]),
    ));
  }
}
