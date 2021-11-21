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
    final buttonFontSize = mediaQuery.size.width / 14;
    final _formKey = GlobalKey<FormState>();

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logoperfect.png",
        height: mediaQuery.size.height / 10,
        width: mediaQuery.size.width / 5,
      ),
    );

    Widget profilesbutton(String locationName) {
      return ElevatedButton(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  mediaQuery.size.width / 22,
                  mediaQuery.size.height / 155,
                  mediaQuery.size.width / 22,
                  mediaQuery.size.height / 155),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locationName,
                    style: GoogleFonts.roboto(
                        fontSize: buttonFontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.chevron_right_outlined,
                      size: mediaQuery.size.width / 10,
                      color: Color(0xff565656))
                ],
              )),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffC4C4C4)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ))),
          onPressed: () {});
    }

    Widget registerContainer() {
      return Column(
        children: [
          buildTopPadding(20, (profilesbutton("Esportista 1"))),
          buildTopPadding(20, (profilesbutton("Esportista 2"))),
          buildTopPadding(20, (profilesbutton("Esportista 3"))),
          buildTopPadding(20, (profilesbutton("Esportista 4"))),
          buildTopPadding(20, (profilesbutton("Esportista 5"))),
          buildTopPadding(20, (profilesbutton("Esportista 6"))),
          buildTopPadding(20, (profilesbutton("Esportista 7"))),
        ],
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: mediaQuery.size.height / 12,
                    bottom: mediaQuery.size.height / 12),
                child: registerContainer())));
  }

  Padding buildTopPadding(double topPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
