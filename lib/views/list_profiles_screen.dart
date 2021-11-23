import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListProfilesScreen extends StatefulWidget {
  const ListProfilesScreen({Key? key}) : super(key: key);

  @override
  _ListProfilesScreenState createState() => _ListProfilesScreenState();
}

class _ListProfilesScreenState extends State<ListProfilesScreen> {
  double valueDistance = 5;

  Padding buildTopPadding(double topPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonFontSize = mediaQuery.size.width / 14;
    final sliderFontSize = mediaQuery.size.width / 20;
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

    Widget profilesContainer() {
      return Container(
        width: mediaQuery.size.width / 1.2,
        child: Column(
          children: [
            buildTopPadding(20, (profilesbutton("Esportista 1"))),
            buildTopPadding(20, (profilesbutton("Esportista 2"))),
            buildTopPadding(20, (profilesbutton("Esportista 3"))),
            buildTopPadding(20, (profilesbutton("Esportista 4"))),
            buildTopPadding(20, (profilesbutton("Esportista 5"))),
            buildTopPadding(20, (profilesbutton("Esportista 6"))),
            buildTopPadding(20, (profilesbutton("Esportista 7"))),
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: mediaQuery.size.height / 30,
                        bottom: mediaQuery.size.height / 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [profilesContainer()],
                    )))));
  }
}
