import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class HomeLoginScreen extends StatefulWidget {
  @override
  _HomeLoginViewState createState() => _HomeLoginViewState();
}

class _HomeLoginViewState extends State<HomeLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    //if user loggedin go to main screen
    //if(FirebaseAuth.instance.currentUser != null)
      //Navigator.of(context).pushNamed(AppRoutes.user_profile);

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

    final passwordField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              obscureText: true,
              controller: _passwordController,
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Senha',
              ),
            ),
          ),
        ));

    final logInButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150),
            child: Text(
              "entrar".toUpperCase(),
              style: GoogleFonts.anton(fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ))),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register_sports);
        });

    final registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildTopPadding(topAndBottomPadding, emailField),
        buildTopPadding(topAndBottomPadding, passwordField),
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 15),
          child: logInButton,
        )
      ],
    );

    final toRegisterScreenButton = MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register);
        },
        child: Text(
          "Cadastre-se",
          style: GoogleFonts.roboto(
              fontSize: mediaQuery.size.width / 24, color: Colors.black, fontWeight: FontWeight.bold),
        ));

    final toForgetPasswordScreenButton = MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.forget_password_email);
        },
        child: Text(
          "Esqueci minha senha",
          style: GoogleFonts.roboto(
              fontSize: mediaQuery.size.width / 24, color: Colors.black, fontWeight: FontWeight.bold),
        ));

    final bottomContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          toRegisterScreenButton,
          toForgetPasswordScreenButton,
        ],
      ),
    );

    final homeContainer = Container(
        width: mediaQuery.size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            buildTopPadding(topAndBottomPadding, logo),
            registerFields,
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  topAndBottomPadding,
                  0,
                  topAndBottomPadding),
              child: bottomContainer,
            )
          ],
        )
    );

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
                )
            )
        )
    );
  }

  Padding buildTopPadding(double topPadding, Material field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
