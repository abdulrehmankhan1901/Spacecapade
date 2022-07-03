import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spacecapade/screens/logIn.dart';

import 'mainmenu.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = "empty";
    String password = "0";

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
                  await auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  errorCode = e.code;
                }
                if (errorCode == null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LogIn()));
                } else if (errorCode == 'weak-password') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Weak Password"),
                          content: Text(
                              "Ensure that the password you entered has atleast 6 characters"),
                        );
                      });
                } else if (errorCode == 'email-already-in-use') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Account exists"),
                          content:
                              Text("User already exists, consider Loggin In."),
                        );
                      });
                }
              },
              child: Text("Register")),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LogIn()));
              },
              child: const Icon(Icons.arrow_back_ios_new),
            )),
      ]),
    ));
  }
}
