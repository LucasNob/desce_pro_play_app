import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class RegisterSportsScreen extends StatefulWidget {
  @override
  _RegisterSportsViewState createState() => _RegisterSportsViewState();
}

class _RegisterSportsViewState extends State<RegisterSportsScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final List<SportsCheckBoxModel> sports = [
      SportsCheckBoxModel(name: "Futebol", icon: Icons.sports_soccer),
      SportsCheckBoxModel(name: "Skate", icon: Icons.skateboarding),
      SportsCheckBoxModel(name: "Basquete", icon: Icons.sports_basketball),
      SportsCheckBoxModel(name: "Football", icon: Icons.sports_football),
      SportsCheckBoxModel(name: "Vôlei", icon: Icons.sports_volleyball),
      SportsCheckBoxModel(name: "Tênis", icon: Icons.sports_tennis),
      SportsCheckBoxModel(name: "Outro", icon: Icons.sports),
    ];

    saveSports(List<SportsCheckBoxModel> sports) async {
      final selection = [];
      sports.forEach((sport) {
        if (sport.check == true) {
          selection.add(sport.name);
        }
      });
      User? user = FirebaseAuth.instance.currentUser;
      String emailId = user!.email.toString();

      CollectionReference userdata =
          FirebaseFirestore.instance.collection('userdata');
      await userdata.doc(emailId).update({'sports': selection});

      user.sendEmailVerification();
      FirebaseAuth.instance.signOut();
    }

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.width / 1.5,
      ),
    );

    final sportsList = Column(
      children: [
        SportCheckboxWidget(item: sports[0]),
        SportCheckboxWidget(item: sports[1]),
        SportCheckboxWidget(item: sports[2]),
        SportCheckboxWidget(item: sports[3]),
        SportCheckboxWidget(item: sports[4]),
        SportCheckboxWidget(item: sports[5]),
        SportCheckboxWidget(item: sports[6]),
      ],
    );

    final completeRegisterButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 25,
                mediaQuery.size.height / 150),
            child: Text(
              "completar cadastro".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ))),
        onPressed: () {
          saveSports(sports);
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.email_verification); //temp user profile
        });

    final sportsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: topAndBottomPadding),
          child: logo,
        ),
        Padding(
            padding: EdgeInsets.only(
                top: mediaQuery.size.height / 12,
                bottom: mediaQuery.size.width / 12),
            child: sportsList),
        Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: completeRegisterButton),
      ]),
    );

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color(0xffFF8A00),
            body: Form(
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: mediaQuery.size.height / 12,
                        bottom: mediaQuery.size.height / 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sportsContainer,
                      ],
                    )))));
  }
}

// Sport tile widget
class SportCheckboxWidget extends StatefulWidget {
  final SportsCheckBoxModel item;

  const SportCheckboxWidget({Key? key, required this.item}) : super(key: key);

  @override
  _SportCheckboxWidgetState createState() => _SportCheckboxWidgetState();
}

class _SportCheckboxWidgetState extends State<SportCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.item.name),
      secondary: Icon(widget.item.icon),
      value: widget.item.check,
      onChanged: (bool? value) {
        setState(() {
          widget.item.check = value;
        });
      },
    );
  }
}

class SportsCheckBoxModel {
  SportsCheckBoxModel(
      {required this.name, required this.icon, this.check = false});

  String name;
  IconData icon;
  bool? check;
}
