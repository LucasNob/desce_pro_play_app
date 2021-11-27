import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';

class LocationProfileScreen extends StatefulWidget {
  const LocationProfileScreen({Key? key, required this.locationName})
      : super(key: key);

  final String locationName;
  @override
  _LocationProfileViewState createState() => _LocationProfileViewState();
}

class _LocationProfileViewState extends State<LocationProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');
  DocumentReference? userDocRef;
  DocumentSnapshot? userDoc;

  CollectionReference locationdata =
      FirebaseFirestore.instance.collection('locationdata');
  DocumentReference? locationDocRef;
  DocumentSnapshot? locationDoc;

  List? users;
  String? user;

  Text buildText(String text, double fontSize, Color color) {
    return Text(text,
        style: GoogleFonts.anton(fontSize: fontSize, color: color));
  }

  Future getName() async {
    userDocRef = userdata.doc(currentUser!.email);
    userDoc = await userDocRef!.get();
    setState(() {
      user = userDoc!.get('first_name') + " " + userDoc!.get('last_name');
      print(user);
    });
  }

  Future usersList() async {
    locationDoc = await locationDocRef!.get();
    users = locationDoc!.get("users");
  }

  void addUser() async {
    await usersList();
    await getName();

    if (!users!.contains(user)) {
      users!.add(user);
      locationDocRef!.update({'users': users});
    }
  }

  void removeUser() async {
    await usersList();
    await getName();

    if (users!.contains(user)) {
      users!.remove(user);
      locationDocRef!.update({'users': users});
    }
  }

  Container buildUserContainer(Widget child, double width, double height) {
    return Container(
        width: width,
        height: height,
        child: child,
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    usersList();

    final loadProfile = FutureBuilder<DocumentSnapshot>(
        future: locationdata.doc(widget.locationName).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Erro ao Carregar");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Dados de local inexistente");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            final imgURL = data['image_url'];

            locationDocRef = locationdata.doc('${data['name']}');

            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Material(
                  //     child: imgURL != null
                  //         ? ClipOval(
                  //             child: Image.network(
                  //               imgURL,
                  //               width: mediaQuery.size.width / 2.5,
                  //               height: mediaQuery.size.height / 4.75,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           )
                  //         : ClipOval(
                  //             child: Image.asset(
                  //               "lib/resources/user_default_profile_image.png",
                  //               width: mediaQuery.size.width / 2.5,
                  //               height: mediaQuery.size.height / 4.75,
                  //               fit: BoxFit.fill,
                  //             ),
                  //           )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText("Nome", labelFontSize, Colors.grey),
                      buildText('${data['name']}', valueFontSize, Colors.black),
                      buildText("${data['about']}", valueFontSize, Colors.black)
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: mediaQuery.size.height / 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("Endereço", labelFontSize, Colors.grey),
                          buildText(
                              "${data['adress']}", valueFontSize, Colors.black)
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText("CEP", labelFontSize, Colors.grey),
                        buildText("${data['cep']}", valueFontSize, Colors.black)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText("Criado por:", labelFontSize, Colors.grey),
                        buildText("${data['created_by']}", valueFontSize,
                            Colors.black)
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Text("loading...");
        });

    final participateButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150),
            child: Text(
              "participar".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff5CD032)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {
          addUser();
          print("participar");
        });

    final exitButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150),
            child: Text(
              "sair".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {
          removeUser();
        });

    Widget participatingUsers() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (var user in users!)
            Padding(
                padding: EdgeInsets.only(top: topAndBottomPadding),
                child: buildUserContainer(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildText(user.toString().toUpperCase(), valueFontSize,
                            Colors.white)
                      ],
                    ),
                    mediaQuery.size.width / 1.5,
                    mediaQuery.size.height / 15))
        ],
      );
    }

    final bodyContainer = Container(
      child: Column(
        children: <Widget>[
          loadProfile,
          Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: mediaQuery.size.width / 10),
                    child: participateButton),
                exitButton,
              ],
            ),
          ),
          users != null ? participatingUsers() : Text("")
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
          widget.locationName,
          style: GoogleFonts.anton(
              fontSize: mediaQuery.size.width / 14, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(top: topAndBottomPadding),
          //child: bodyContainer,
          child: bodyContainer,
        ),
      ])),
    );
  }
}
