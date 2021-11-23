import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({Key? key}) : super(key: key);

  @override
  _ListLocationScreenState createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  double valueDistance = 5;

  var location = new Location();
  var serviceEnabled;
  var currentLocation;

  void checkService() async {
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    } else {
      currentLocation = await location.getLocation();
      print(currentLocation);
    }
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
    final _formKey = GlobalKey<FormState>();

    if (serviceEnabled == null) {
      checkService();
    }

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

    Widget buildSlider() {
      final double min = 1;
      final double max = 25;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(valueDistance.ceil().toString() + ' KM',
              style: GoogleFonts.anton(
                  fontSize: sliderFontSize, color: Colors.black)),
          Row(
            children: [
              buildSideLabel(min),
              Expanded(
                child: Slider(
                  value: valueDistance,
                  min: min,
                  max: max,
                  divisions: 5,
                  activeColor: Color(0xffFF8A00),
                  label: valueDistance.round().toString(),
                  onChanged: (double newValue) =>
                      {setState(() => valueDistance = newValue)},
                ),
              ),
              buildSideLabel(max),
            ],
          )
        ]),
      );
    }

    Widget locationsbutton(String locationName) {
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
                    locationName,
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
          onPressed: () {});
    }

    Widget registerContainer() {
      return Container(
        width: mediaQuery.size.width / 1.2,
        child: Column(
          children: [
            buildTopPadding(10, (buildSlider())),
            buildTopPadding(20, (locationsbutton("Local 1"))),
            buildTopPadding(20, (locationsbutton("Local 2"))),
            buildTopPadding(20, (locationsbutton("Local 3"))),
            buildTopPadding(20, (locationsbutton("Local 4"))),
            buildTopPadding(20, (locationsbutton("Local 5"))),
            buildTopPadding(20, (locationsbutton("Local 6"))),
            buildTopPadding(20, (locationsbutton("Local 7"))),
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: mediaQuery.size.height / 30,
                        bottom: mediaQuery.size.height / 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [registerContainer()],
                    )))));
  }
}
