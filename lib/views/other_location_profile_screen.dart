import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherLocationProfileScreen extends StatefulWidget {
  const OtherLocationProfileScreen({Key? key}) : super(key: key);

  @override
  _OtherLocationProfileScreenState createState() =>
      _OtherLocationProfileScreenState();
}

class _OtherLocationProfileScreenState
    extends State<OtherLocationProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _userImage;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logoperfect.png",
        height: mediaQuery.size.height / 10,
        width: mediaQuery.size.width / 5,
      ),
    );

    Widget pictureContainer() {
      return Material(
        child: _userImage != null
            ? ClipRect(
                child: Image.file(
                  _userImage!,
                  width: mediaQuery.size.width / 1,
                  height: mediaQuery.size.height / 4,
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
              ),
      );
    }

    Widget textTitle(String text, double fontSize, color) {
      return Text(text,
          style: GoogleFonts.anton(fontSize: fontSize, color: color));
    }

    Widget registerContainer() {
      return Column(
        children: [
          pictureContainer(),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            buildTopPadding(
                15, 15, textTitle('Nome do Local', 25, Colors.black))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(5, 15, textTitle('Endereço', 18, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(5, 15, textTitle('CEP', 16, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(20, 15, textTitle('Contato', 12, Colors.grey)),
              buildTopPadding(20, 115, textTitle('Entrada', 12, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(5, 15, textTitle('Talento', 15, Colors.black)),
              buildTopPadding(
                  5, 108, textTitle('Entrada do Local', 15, Colors.black))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(
                  20, 15, textTitle('Esportes Praticáveis', 12, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(5, 15,
                  textTitle('Lista Esportes Praticáveis', 15, Colors.black))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(
                  20, 15, textTitle('Tipo de Quadra', 12, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(
                  5, 15, textTitle('Lista Tipo de Quadra', 15, Colors.black))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(20, 15, textTitle('Sobre', 12, Colors.grey))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(5, 15, textTitle('Descrição', 17, Colors.black))
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left, size: mediaQuery.size.width / 8),
        ),
        centerTitle: true,
        title: Text(
          "Local",
          style: GoogleFonts.anton(
              fontSize: mediaQuery.size.width / 14, color: Colors.white),
        ),
        actions: [logo],
        backgroundColor: Color(0xffFF8A00),
      ),
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(child: registerContainer())),
    );
  }

  Padding buildTopPadding(double topPadding, double leftPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: field,
    );
  }
}
