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

  var imgURL;

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

  Text buildText(String text, fontSize, color) {
    return Text(text,
        style: GoogleFonts.anton(fontSize: fontSize, color: color));
  }

  Padding buildTopPadding(double topPadding, Widget widget) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: widget,
    );
  }

  Container buildUserContainer(Widget child, double width, double height) {
    return Container(
        width: width,
        height: height,
        child: child,
        decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.all(Radius.circular(5))));
  }

  Container buildInformationContainer(Widget label, Widget value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [label, value],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final buttonWidth = mediaQuery.size.width / 20;
    final buttonHeight = mediaQuery.size.height / 150;

    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;

    final topAndBottomPadding = mediaQuery.size.height / 30;

    Widget informationsContainer(
            name, address, cep, contact, tax, sports, courtType, about) =>
        Container(
            width: mediaQuery.size.width / 1.1,
            child: Padding(
              padding: EdgeInsets.only(
                  top: topAndBottomPadding, left: mediaQuery.size.width / 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(name, valueFontSize, Colors.black),
                    buildText(address, valueFontSize, Colors.grey),
                    buildText("CEP: " + cep, valueFontSize, Colors.grey),
                    Padding(
                        padding: EdgeInsets.only(top: topAndBottomPadding),
                        child: buildInformationContainer(
                            buildText("Contato", labelFontSize, Colors.grey),
                            buildText(contact, valueFontSize, Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(top: topAndBottomPadding),
                        child: buildInformationContainer(
                            buildText("Taxa", labelFontSize, Colors.grey),
                            buildText(tax != "" ? tax : "Grátis", valueFontSize,
                                Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(top: topAndBottomPadding),
                        child: buildInformationContainer(
                            buildText("Esportes práticaveis", labelFontSize,
                                Colors.grey),
                            buildText(sports, valueFontSize, Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(top: topAndBottomPadding),
                        child: buildInformationContainer(
                            buildText(
                                "Tipo de quadra", labelFontSize, Colors.grey),
                            buildText(courtType, valueFontSize, Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: topAndBottomPadding,
                            bottom: topAndBottomPadding),
                        child: buildInformationContainer(
                            buildText("Sobre", labelFontSize, Colors.grey),
                            buildText(about, valueFontSize, Colors.black))),
                  ]),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))));

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

            locationDocRef = locationdata.doc('${data['name']}');

            imgURL = data['image_url'];

            return informationsContainer(
                data['name'],
                data['adress'],
                data['cep'],
                data['created_by'],
                data['fee'],
                data['sports'],
                data['court_type'],
                data['about']);
          }
          return Text("loading...");
        });

    final localImage = Material(
        color: Colors.transparent,
        child: imgURL != null
            ? ClipRRect(
                child: Image.network(
                  imgURL,
                  height: mediaQuery.size.height / 5,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRect(
                child: Image.asset(
                  "lib/resources/localgenerico.png",
                  width: mediaQuery.size.width / 1,
                  height: mediaQuery.size.height / 4,
                  fit: BoxFit.cover,
                ),
              ));

    final participateButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                buttonWidth, buttonHeight, buttonWidth, buttonHeight),
            child: Text(
              "participar".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.white),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ))),
        onPressed: () {
          addUser();
        });

    final exitButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                buttonWidth, buttonHeight, buttonWidth, buttonHeight),
            child: Text(
              "sair".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.white),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ))),
        onPressed: () {
          removeUser();
        });

    final participationButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [participateButton, exitButton],
    );

    Widget getUsers() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var user in users!)
              Padding(
                  padding: EdgeInsets.only(top: topAndBottomPadding),
                  child: buildUserContainer(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildText(user.toString().toUpperCase(),
                              valueFontSize, Colors.white)
                        ],
                      ),
                      mediaQuery.size.width / 1.2,
                      mediaQuery.size.height / 15))
          ],
        );

    final participationContainer = Container(
        width: mediaQuery.size.width / 1.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(8),
                child: buildText("participantes".toUpperCase(), valueFontSize,
                    Colors.black)),
            Padding(
              padding: EdgeInsets.all(8),
              child: participationButtons,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: users != null ? getUsers() : Text(""),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))));

    Widget bodyContainer() => Container(
          child: Column(
            children: [
              localImage,
              Padding(
                padding: EdgeInsets.only(top: topAndBottomPadding),
                child: loadProfile,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: topAndBottomPadding, bottom: topAndBottomPadding),
                child: participationContainer,
              )
            ],
          ),
        );

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.grey,
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                  padding: EdgeInsets.only(top: topAndBottomPadding),
                  //child: bodyContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [bodyContainer()],
                  ),
                ),
              ])),
        ));
  }
}
