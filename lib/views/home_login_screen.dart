import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeLoginScreen extends StatefulWidget {
  @override
  _HomeLoginViewState createState() => _HomeLoginViewState();
}

class _HomeLoginViewState extends State<HomeLoginScreen> {
  final auth = FirebaseAuth.instance;
  String _email = "email";
  String _password = "password";

  @override
  Widget build(BuildContext context) {
    final logo = Material(
      elevation: 20,
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: 200,
        width: 200,
      ),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: logo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}