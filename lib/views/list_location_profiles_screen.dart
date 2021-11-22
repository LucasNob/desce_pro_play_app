import 'package:desce_pro_play_app/views/list_location_screen.dart';
import 'package:desce_pro_play_app/views/list_profiles_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';

class ListLocationProfilesScreen extends StatefulWidget {
  const ListLocationProfilesScreen({Key? key}) : super(key: key);

  @override
  _ListLocationProfileScreenState createState() =>
      _ListLocationProfileScreenState();
}

class _ListLocationProfileScreenState
    extends State<ListLocationProfilesScreen> {
  int contador = 0;
  PageController _pageController = PageController(initialPage: 0);
  final optionsbottom = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.location_city,
          color: Colors.black,
        ),
        title: Text(
          "Locais",
          style: GoogleFonts.anton(color: Colors.black),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.location_history_rounded,
          color: Colors.black,
        ),
        title: Text(
          "Esportistas",
          style: GoogleFonts.anton(color: Colors.black),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logoperfect.png",
        height: mediaQuery.size.height / 10,
        width: mediaQuery.size.width / 5,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          leading: logo,
          centerTitle: true,
          title: Text(
            "Lista",
            style: GoogleFonts.anton(
                fontSize: mediaQuery.size.width / 14, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.user_profile);
                },
                icon: Icon(Icons.account_circle,
                    size: mediaQuery.size.width / 10))
          ],
          backgroundColor: Color(0xffFF8A00),
        ),
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: (newindex) {
            setState(() {
              contador = newindex;
            });
          },
          children: [ListLocationScreen(), ListProfilesScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: contador,
          items: optionsbottom,
          backgroundColor: Color(0xffFF8A00),
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ));
  }
}
