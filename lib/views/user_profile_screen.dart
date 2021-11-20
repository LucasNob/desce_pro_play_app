import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  File? _userImage;
  final picker = ImagePicker();

  Future uploadImageToFirebase() async {
    String fileName = basename(_userImage!.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference firebaseStorageRef = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_userImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => print("Done: $value"));
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

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
                      buildText("Nome", labelFontSize, Colors.grey),
                      buildText(
                          '${data['first_name']}', valueFontSize, Colors.black),
                      buildText(
                          "${data['last_name']}", valueFontSize, Colors.black)
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: mediaQuery.size.height / 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("Nascimento", labelFontSize, Colors.grey),
                          buildText("${data['birth_date']}", valueFontSize,
                              Colors.black)
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
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

    final openGallery = IconButton(
      icon: Icon(Icons.photo_camera),
      onPressed: () {
        pickImage();
      },
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
      children: [userAvatar, openGallery],
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
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register_location);
        });

    final bodyContainer = Container(
      child: Column(
        children: <Widget>[
          informationsContainer,
          locationsContainer,
          Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
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
              onPressed: () {
                FirebaseAuth.instance.userChanges().listen((User? user) {
                  user = null;
                });
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.exit_to_app, size: mediaQuery.size.width / 10))
        ],
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
