import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/views/location_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference userData =
      FirebaseFirestore.instance.collection('userdata');
  DocumentReference? userDocRef;
  DocumentSnapshot? userDoc;

  File? _userImage;
  final picker = ImagePicker();

  var imgURL;

  Future uploadImageToFirebase() async {
    String fileName = basename(_userImage!.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference firebaseStorageRef = storage.ref().child('user-images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_userImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref
        .getDownloadURL()
        .then((value) async =>
            await userData.doc(currentUser!.email).update({'image_url': value}))
        .then((value) => setState(() {}));
  }

  Future pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _userImage = File(pickedFile!.path);
        uploadImageToFirebase();
      });
    } on PlatformException catch (e) {
      print("Falha ao escolher foto: $e");
    }
  }

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

  void getImageURL() async {
    userDocRef = userData.doc(currentUser!.email);
    userDoc = await userDocRef!.get();
    imgURL = userDoc!.get('image_url').toString();
    print(imgURL);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    if (imgURL == null) {
      setState(() {
        getImageURL();
      });
    }

    final openGallery = IconButton(
      icon: Icon(Icons.photo_camera),
      onPressed: () {
        pickImage();
      },
    );

    List sportsRow(List sports) {
      List s = [];
      for (var i = 0; i < sports.length; i++)
        switch (sports[i]) {
          case ('Futebol'):
            s.add(Icons.sports_soccer);
            break;
          case ('Skate'):
            s.add(Icons.skateboarding);
            break;
          case ('Basquete'):
            s.add(Icons.sports_basketball);
            break;
          case ('Football'):
            s.add(Icons.sports_football);
            break;
          case ('Vôlei'):
            s.add(Icons.sports_volleyball);
            break;
          case ('Tênis'):
            s.add(Icons.sports_tennis);
            break;
          case ('Outro'):
            s.add(Icons.sports);
            break;
        }
      return s;
    }

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
                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQuery.size.height / 90),
                              child: Row(children: <Widget>[
                                for (var icon in sportsRow(data['sports']))
                                  Icon(icon)
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildUserAvatar(imgURL, mediaQuery.size.width / 2.5,
                          mediaQuery.size.height / 4.75),
                      openGallery
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
      height: mediaQuery.size.height / 2.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(),
          child: loadProfile,
        ),
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
                if(document['created_by'] == currentUser!.email)
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

    final editInformationsButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150),
            child: Text(
              "editar informações".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.white),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.user_edit_informations);
        });

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
                  fontSize: buttonFontSize, color: Colors.white),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register_location);
        });

    final bodyContainer = Container(
      child: Column(
        children: <Widget>[
          informationsContainer,
          Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: editInformationsButton,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: newLocationButton,
          ),
          locationsContainer
        ],
      ),
    );

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffFF8A00),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.list_location_profiles);
              },
              icon: Icon(Icons.chevron_left, size: mediaQuery.size.width / 10),
            ),
            title: Text(
              "Meu Perfil",
              style: GoogleFonts.anton(
                  fontSize: mediaQuery.size.width / 14, color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.userChanges().listen((User? user) {
                      user = null;
                    });
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon:
                      Icon(Icons.exit_to_app, size: mediaQuery.size.width / 10))
            ],
          ),
          body: SingleChildScrollView(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(
                  top: topAndBottomPadding, bottom: topAndBottomPadding),
              child: bodyContainer,
            ),
          ])),
        ));
  }
}
