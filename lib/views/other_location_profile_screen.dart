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
      return Material();
    }

    Widget registerContainer() {
      return Column(
        children: [
          pictureContainer(),
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
}
