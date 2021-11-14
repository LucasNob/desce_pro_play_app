import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userdata');

    final mediaQuery = MediaQuery.of(context);

    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    //on user log out
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null)
        Navigator.of(context).pushNamed(AppRoutes.home_login);
      else
        user = null;
    });

    //loads user data
    final loadProfile = FutureBuilder<DocumentSnapshot>(
        future: userData.doc(currentUser!.email).get(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome",
                          style: GoogleFonts.anton(
                              fontSize: labelFontSize, color: Colors.grey)),
                      Text("${data['first_name']}",
                          style: GoogleFonts.anton(
                              fontSize: valueFontSize, color: Colors.black)),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: mediaQuery.size.height / 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nascimento",
                              style: GoogleFonts.anton(
                                  fontSize: labelFontSize, color: Colors.grey)),
                          Text("${data['birth_date']}",
                              style: GoogleFonts.anton(
                                  fontSize: valueFontSize,
                                  color: Colors.black)),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sexo",
                            style: GoogleFonts.anton(
                                fontSize: labelFontSize, color: Colors.grey)),
                        Text("${data['user_gender']}",
                            style: GoogleFonts.anton(
                                fontSize: valueFontSize, color: Colors.black)),
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
          }
          return Text("loading...");
        });

    final informationsContainer = Container(
      width: mediaQuery.size.width / 1.2,
      height: mediaQuery.size.height / 2.3,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [loadProfile, loadProfile]),
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
        )
      ]),
    );

    final newLocationButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150),
            child: Text(
              "criar local".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff5CD032)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {});

    final bodyContainer = Container(
      child: Column(
        children: <Widget>[
          informationsContainer,
          locationsContainer,
          Padding(
            padding: EdgeInsets.only(top: topAndBottomPadding),
            child: newLocationButton,
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
            "Meu Perfil",
            style: GoogleFonts.anton(
                fontSize: mediaQuery.size.width / 14, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout_rounded,
                    size: mediaQuery.size.width / 10))
          ],
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(top: topAndBottomPadding),
            child: bodyContainer,
          ),
        ]));
  }
}
