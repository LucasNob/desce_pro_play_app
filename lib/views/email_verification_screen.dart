import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.width / 1.5,
      ),
    );

    final loginScreenButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150),
            child: Text(
              "Continuar".toUpperCase(),
              style: GoogleFonts.anton(fontSize: fontSize, color: Colors.black),
            )
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )
            )
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.home_login);//temp user profile
        }
    );


    final sportsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: topAndBottomPadding),
              child: logo,
          ),
          Padding(
              padding: EdgeInsets.only(top: mediaQuery.size.height/12, bottom: mediaQuery.size.width/12),
              child: Text(
                  "Email não verificado",
                  style: GoogleFonts.anton(fontSize: fontSize, color: Colors.black),)
          ),
          Padding(
              padding: EdgeInsets.only(top: topAndBottomPadding, bottom: topAndBottomPadding),
              child: Text(
                "Vasculhe a sua caixa de entrada",
                style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.black))
          ),
          Padding(
              padding: EdgeInsets.only(top: topAndBottomPadding, bottom: topAndBottomPadding),
              child: loginScreenButton
          ),
        ]
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xffFF8A00),
        body: Form(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(top: mediaQuery.size.height / 12, bottom: mediaQuery.size.height / 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sportsContainer,
                  ],
                )
            )
        )
    );
  }
}

// Sport tile widget
class SportCheckboxWidget extends StatefulWidget{

  final SportsCheckBoxModel item;

  const SportCheckboxWidget({Key? key, required this.item}) : super(key:key);

  @override
  _SportCheckboxWidgetState createState() => _SportCheckboxWidgetState();
}

class _SportCheckboxWidgetState extends State<SportCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title:      Text(widget.item.name),
      secondary:  Icon(widget.item.icon),
      value: widget.item.check,
      onChanged: (bool? value){
        setState((){
          widget.item.check = value;
        });
      },
    );
  }
}

class SportsCheckBoxModel {
  SportsCheckBoxModel({required this.name,required this.icon,this.check= false});

  String name;
  IconData icon;
  bool? check;
}