import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListProfilesScreen extends StatefulWidget {
  const ListProfilesScreen({Key? key}) : super(key: key);

  @override
  _ListProfilesScreenState createState() => _ListProfilesScreenState();
}

class _ListProfilesScreenState extends State<ListProfilesScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logoperfect.png",
        height: mediaQuery.size.height / 10,
        width: mediaQuery.size.width / 5,
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Esportistas')));
  }
}
