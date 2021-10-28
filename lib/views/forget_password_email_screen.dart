import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  @override
  _ForgetPasswordEmailViewState createState() =>
      _ForgetPasswordEmailViewState();
}

class _ForgetPasswordEmailViewState extends State<ForgetPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.width / 1.5,
      ),
    );

    final emailField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _emailController,
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'E-mail',
              ),
            ),
          ),
        ));

    final recoverPasswordButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150),
            child: Text(
              "recuperar senha".toUpperCase(),
              style: GoogleFonts.anton(fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ))),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.forget_password);
        });

    final registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildTopPadding(topAndBottomPadding, emailField),
        Padding(
          padding: EdgeInsets.only(
              top: topAndBottomPadding,
              bottom: topAndBottomPadding),
          child: recoverPasswordButton,
        )
      ],
    );

    final homeContainer = Container(
        width: mediaQuery.size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            buildTopPadding(topAndBottomPadding, logo),
            registerFields,
          ],
        ));

    return Scaffold(
        backgroundColor: Color(0xffFF8A00),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 12, 0,
                    mediaQuery.size.height / 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    homeContainer,
                  ],
                ))));
  }

  Padding buildTopPadding(double topPadding, Material field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
