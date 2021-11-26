import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/views/location_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({Key? key}) : super(key: key);

  @override
  _ListLocationScreenState createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  double valueDistance = 5;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonFontSize = mediaQuery.size.width / 14;
    final sliderFontSize = mediaQuery.size.width / 20;
    final _formKey = GlobalKey<FormState>();

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logoperfect.png",
        height: mediaQuery.size.height / 10,
        width: mediaQuery.size.width / 5,
      ),
    );

    Widget buildSideLabel(double value) => Container(
          child: Text(
            value.round().toString() + ' KM',
            style: GoogleFonts.roboto(
                fontSize: sliderFontSize,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        );

    Widget buildSliderSideLabel() {
      final double min = 1;
      final double max = 90;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          children: [
            buildSideLabel(min),
            Expanded(
              child: Slider(
                value: valueDistance,
                min: min,
                max: max,
                activeColor: Color(0xffFF8A00),
                label: valueDistance.round().toString(),
                onChanged: (newValue) =>
                    {setState(() => valueDistance = newValue)},
              ),
            ),
            buildSideLabel(max),
          ],
        ),
      );
    }

    Widget toLocationButton (name) {
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
                    name,
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

    Widget registerContainer() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('locationdata').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((documents){
                return Padding(
                  padding: EdgeInsets.only(top: mediaQuery.size.height / 50),
                  child: toLocationButton(documents['name']),
                );
              }).toList(),
            );
          }
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: mediaQuery.size.height / 30,
                    bottom: mediaQuery.size.height / 30),
                child: registerContainer())));
  }

  Padding buildTopPadding(double topPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
