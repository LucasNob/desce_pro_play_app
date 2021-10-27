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

    final fontSize = mediaQuery.size.width / 12;
    //final topPadding = mediaQuery.size.height / 30;

    final List<SportsCheckBoxModel> sports = [
      SportsCheckBoxModel(name: "Futebol",  icon: Icons.sports_soccer),
      SportsCheckBoxModel(name: "Skate",    icon: Icons.skateboarding),
      SportsCheckBoxModel(name: "Basquete", icon: Icons.sports_basketball),
      SportsCheckBoxModel(name: "Football", icon: Icons.sports_football),
      SportsCheckBoxModel(name: "Vôlei", icon: Icons.sports_volleyball),
      SportsCheckBoxModel(name: "Tênis", icon: Icons.sports_tennis),
      SportsCheckBoxModel(name: "Outro", icon: Icons.sports),
    ];

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

    final completeButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150),
            child: Text(
              "COMPLETAR CADASTRO",
              style: GoogleFonts.anton(fontSize: fontSize/1.5, color: Colors.black),
            )
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                )
            )
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.home_login);
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
          logo,
          Padding(
              padding: EdgeInsets.fromLTRB(0,mediaQuery.size.height/12,0,mediaQuery.size.width/12),
              child: sportsList
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 20, 0, mediaQuery.size.height / 20),
              child: completeButton
          ),
        ]
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xffFF8A00),
        body: Form(
            //key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 12, 0, mediaQuery.size.height / 12),
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
class SportsCheckBoxModel{
  SportsCheckBoxModel({required this.name,required this.icon,this.check= false});

  String name;
  IconData icon;
  bool? check;
}