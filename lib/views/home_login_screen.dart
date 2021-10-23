import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeLoginScreen extends StatefulWidget {
  @override
  _HomeLoginViewState createState() => _HomeLoginViewState();
}

class _HomeLoginViewState extends State<HomeLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // Responsividade

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.height / 4,
      ),
    );

    final logInButton = SizedBox(
      width: mediaQuery.size.width / 1.5,
      height: mediaQuery.size.width / 6,
      child: MaterialButton(
        color: Color(0xffFF8A00),
        onPressed: () {},
        child: Text(
          "Entrar",
          style: GoogleFonts.anton(fontSize: 30, color: Colors.black),
        ),
      ),
    );

    final bottom = SizedBox(
      width: mediaQuery.size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              //Navigator.of(context).pushNamed(AppRoutes.register_user);
            },
            child: Text(
              "Cadastre-se",
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            )
          ),
          MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              //Navigator.of(context).pushNamed(AppRoutes.register_user);
            },
            child: Padding(
              padding: EdgeInsets.only(left: mediaQuery.size.width / 30),
              child: Text(
                "Esqueci minha senha",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final homeContainer = Container(
      width: mediaQuery.size.width / 1.2,
      height: mediaQuery.size.height / 1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          logo,
          Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 25),
            child: logInButton,
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 25),
            child: bottom,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xffFF8A00),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 12, 0, mediaQuery.size.height / 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            homeContainer
          ],
        )
      ),
    );
  }
}