import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/views/location_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({Key? key}) : super(key: key);

  @override
  _ListLocationScreenState createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  double valueDistance = 5;
  Map<String, double> locationList = {};

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  _getLocationDistance() async {
    Position userPosition = await _determinePosition();
    double distance;
    locationList.clear();
    print("User Latitude " +
        userPosition.latitude.toString() +
        ", Latitude " +
        userPosition.latitude.toString());

    await FirebaseFirestore.instance
        .collection('locationdata')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        distance = Geolocator.distanceBetween(doc['latitude'], doc['longitude'],
            userPosition.latitude, userPosition.longitude);

        print("${doc['name']} " + distance.toString());

        if (distance <= valueDistance * 1000) {
          locationList[doc['name']] = distance;
        }
      });
    });
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

    _getLocationDistance();

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
      String localName = name.substring(0, 6).trim();

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
                          localName + " ...",
                          style: GoogleFonts.anton(
                              fontSize: buttonFontSize, color: Colors.black),
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

    List<Widget> getLocationsList() {
      List<Widget> list = [];
      locationList.forEach((key, value) {
        list.add(toLocationButton(key, value));
      });
      return list;
    }

    Widget getLocations() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getLocationsList(),
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
            getLocations()
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
