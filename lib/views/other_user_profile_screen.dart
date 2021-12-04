import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'location_profile_screen.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({Key? key, required this.userEmail})
      : super(key: key);

  final String userEmail;

  @override
  _OtherUserProfileViewState createState() => _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends State<OtherUserProfileScreen> {
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');

  File? _userImage;

  Text buildText(String text, fontSize, color) {
    return Text(text,
        style: GoogleFonts.anton(fontSize: fontSize, color: color));
  }

  Material buildUserAvatar(var imageURL, width, height) {
    if (imageURL == null || imageURL == "") {
      return Material(
          child: ClipOval(
        child: Image.asset(
          "lib/resources/user_default_profile_image.png",
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ));
    } else {
      return Material(
          child: ClipOval(
        child: Image.network(
          imageURL,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final loadProfile = FutureBuilder<DocumentSnapshot>(
        future: userdata.doc(widget.userEmail).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Erro ao Carregar");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Dados de usuario inexistente");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              width: mediaQuery.size.width / 1.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("Nome", labelFontSize, Colors.grey),
                          buildText('${data['first_name']}', valueFontSize,
                              Colors.black),
                          buildText("${data['last_name']}", valueFontSize,
                              Colors.black)
                        ],
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: mediaQuery.size.height / 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText(
                                  "Nascimento", labelFontSize, Colors.grey),
                              buildText("${data['birth_date']}", valueFontSize,
                                  Colors.black)
                            ],
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(top: mediaQuery.size.height / 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildText("Sexo", labelFontSize, Colors.grey),
                            buildText("${data['user_gender']}", valueFontSize,
                                Colors.black)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: mediaQuery.size.height / 35,
                          bottom: mediaQuery.size.height / 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Esportes Favoritos",
                                style: GoogleFonts.anton(
                                    fontSize: labelFontSize,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        child: buildUserAvatar(
                            data['image_url'],
                            mediaQuery.size.width / 2.5,
                            mediaQuery.size.height / 4.75),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return Text("loading...");
        });

    final informationsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      height: mediaQuery.size.height / 2.3,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        loadProfile,
      ]),
    );

    Widget toLocationButton(String name) {
      String localName = name.substring(0, 5).trim();

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
                    localName + " ...",
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationProfileScreen(locationName: name),
              ),
            );
          });
    }

    final locationsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      child: StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection('locationdata').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List<Widget> locationlist  =[];
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              for (QueryDocumentSnapshot document in snapshot.data!.docs){
                if(document['created_by'] == widget.userEmail)
                  locationlist.add(
                      Padding(
                        padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
                        child: toLocationButton(document['name']),
                      )
                  );
              }
              return Column(
                children: locationlist,
              );
            }
          }),
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
          onPressed: () {
            Navigator.pop(context);
          },
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
