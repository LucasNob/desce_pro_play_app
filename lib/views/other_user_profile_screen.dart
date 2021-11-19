import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({Key? key}) : super(key: key);

  @override
  _OtherUserProfileViewState createState() => _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends State<OtherUserProfileScreen> {
  File? _userImage;

  Text buildText(String text, fontSize, color) {
    return Text(text,
        style: GoogleFonts.anton(fontSize: fontSize, color: color));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final loadProfile = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText("Nome", labelFontSize, Colors.grey),
              buildText('Ana', valueFontSize, Colors.black),
              buildText('Nascimento', valueFontSize, Colors.black)
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText("Nascimento", labelFontSize, Colors.grey),
                  buildText("01/01/2000", valueFontSize, Colors.black)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText("Sexo", labelFontSize, Colors.grey),
                buildText("Feminino", valueFontSize, Colors.black)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Esportes Favoritos",
                    style: GoogleFonts.anton(
                        fontSize: labelFontSize, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );

    final userAvatar = Material(
        child: _userImage != null
            ? ClipOval(
                child: Image.file(
                  _userImage!,
                  width: mediaQuery.size.width / 2.5,
                  height: mediaQuery.size.height / 4.75,
                  fit: BoxFit.cover,
                ),
              )
            : ClipOval(
                child: Image.asset(
                  "lib/resources/user_default_profile_image.png",
                  width: mediaQuery.size.width / 2.5,
                  height: mediaQuery.size.height / 4.75,
                  fit: BoxFit.cover,
                ),
              ));

    final profileImage = Column(
      children: [userAvatar],
    );

    final informationsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      height: mediaQuery.size.height / 2.3,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(right: mediaQuery.size.width / 14),
          child: loadProfile,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [profileImage],
        ),
      ]),
    );

    final toLocationButton = ElevatedButton(
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
                  "Local",
                  style: GoogleFonts.roboto(
                      fontSize: buttonFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.chevron_right_outlined,
                    size: mediaQuery.size.width / 10, color: Color(0xff565656))
              ],
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffC4C4C4)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {
          //userSignIn(_emailController.text, _passwordController.text);
        });

    final locationsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Locais Recentes",
            style:
                GoogleFonts.anton(fontSize: labelFontSize, color: Colors.grey)),
        toLocationButton,
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
          child: toLocationButton,
        ),
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
          child: toLocationButton,
        ),
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
          child: toLocationButton,
        ),
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
          child: toLocationButton,
        ),
        Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
          child: toLocationButton,
        ),
      ]),
    );

    final bodyContainer = Container(
      child: Column(
        children: <Widget>[
          informationsContainer,
          Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: locationsContainer,
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF8A00),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left, size: mediaQuery.size.width / 10),
        ),
        title: Text(
          "Perfil",
          style: GoogleFonts.anton(
              fontSize: mediaQuery.size.width / 14, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(top: topAndBottomPadding),
          child: bodyContainer,
        ),
      ])),
    );
  }
}
