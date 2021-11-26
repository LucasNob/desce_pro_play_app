import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';

class LocationProfileScreen extends StatefulWidget {
  const LocationProfileScreen({Key? key,required this.locationName}) : super(key: key);

  final String locationName;
  @override
  _LocationProfileViewState createState() => _LocationProfileViewState();
}

class _LocationProfileViewState extends State<LocationProfileScreen> {

  Text buildText(String text, fontSize, color) {
    return Text(text,
        style: GoogleFonts.anton(fontSize: fontSize, color: color));
  }
  CollectionReference locationdata
    = FirebaseFirestore.instance.collection('locationdata');

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final labelFontSize = mediaQuery.size.width / 22;
    final valueFontSize = mediaQuery.size.width / 18;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

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
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            final imgURL = data['image_url'];

            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imgURL,
                    height: mediaQuery.size.height/5,
                    width: mediaQuery.size.width,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText("Nome", labelFontSize, Colors.grey),
                      buildText(
                          '${data['name']}', valueFontSize, Colors.black),
                      buildText(
                          "${data['about']}", valueFontSize, Colors.black)
                    ],
                  ),
                  Padding(
                      padding:
                      EdgeInsets.only(top: mediaQuery.size.height / 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("Endereço", labelFontSize, Colors.grey),
                          buildText("${data['adress']}", valueFontSize,
                              Colors.black)
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: mediaQuery.size.height / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText("CEP", labelFontSize, Colors.grey),
                        buildText("${data['cep']}", valueFontSize,
                            Colors.black)
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: topAndBottomPadding),
                  //child: bodyContainer,
                  child: loadProfile,
                ),
              ])),
    );
  }
}
