import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/views/location_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({Key? key}) : super(key: key);

  @override
  _ListLocationScreenState createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  double valueDistance = 5;
  Position ?userPosition;

  _getUserPosition() async {
    await Geolocator.isLocationServiceEnabled();
    await Geolocator.checkPermission();
    userPosition = await Geolocator.getCurrentPosition();
  }

  Padding buildTopPadding(double topPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonFontSize = mediaQuery.size.width / 14;
    final sliderFontSize = mediaQuery.size.width / 20;
    final topAndBottomPadding = mediaQuery.size.height / 30;
    final _formKey = GlobalKey<FormState>();

    _getUserPosition();

    Widget buildSideLabel(double value) => Container(
          child: Text(
            value.round().toString() + ' KM',
            style: GoogleFonts.anton(
              fontSize: sliderFontSize,
              color: Colors.black,
            ),
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

    Widget toLocationButton(String name, double distance) {
      return Padding(
        padding: EdgeInsets.only(top: topAndBottomPadding),
        child: ElevatedButton(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    mediaQuery.size.width / 22,
                    mediaQuery.size.height / 155,
                    mediaQuery.size.width / 22,
                    mediaQuery.size.height / 155),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.anton(
                              fontSize: mediaQuery.size.width / 24,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          (distance.ceil() / 1000).toString() + " KM",
                          style: GoogleFonts.anton(
                              fontSize: buttonFontSize / 2,
                              color: Colors.black),
                        )
                      ],
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
                  builder: (context) =>
                      LocationProfileScreen(locationName: name),
                ),
              );
            }),
      );
    }

    final getLocations = Container(
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
                double distance = Geolocator.distanceBetween(
                    document['latitude'],
                    document['longitude'],
                    userPosition!.latitude,
                    userPosition!.longitude);
                if( distance <= valueDistance * 1000)
                  locationlist.add(
                      Container(
                        child: toLocationButton(document['name'],distance),
                      )
                  );
              }
              return Column(
                children: locationlist,
              );
            }
          }),
    );

    Widget locationsContainer() {
      return Container(
        width: mediaQuery.size.width / 1.2,
        child: Column(
          children: [
            Text(valueDistance.ceil().toString() + " KM",
                style: GoogleFonts.anton(
                    fontSize: buttonFontSize, color: Colors.black)),
            buildTopPadding(topAndBottomPadding, buildSliderSideLabel()),
            getLocations
          ],
        ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    locationsContainer(),
                  ],
                ))));
  }
}
