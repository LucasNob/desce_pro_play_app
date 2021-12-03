import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserEditInformationsScreen extends StatefulWidget {
  @override
  _UserEditInformationsViewState createState() =>
      _UserEditInformationsViewState();
}

class _UserEditInformationsViewState extends State<UserEditInformationsScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');

  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _gender = "Masculino";
  int _radioId = 0;
  DateTime? pickedDate;

  void _showErrorSnack(String error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  Future updateInformation(context) async {
    try {
      await userdata.doc(currentUser!.email).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'birth_date': DateFormat('dd-MM-yyyy').format(pickedDate!).toString(),
        'phone_number': _phoneNumberController.text,
        'user_gender': _gender,
        'sports': []
      });

      Navigator.of(context).pushNamed(AppRoutes.user_profile);
    } catch (error) {
      _showErrorSnack(error.toString(), context);
    }
  }

  Padding buildPadding(Widget widget, double topPadding, double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final containerWidth = mediaQuery.size.width / 1.1;
    final topAndBottomPadding = mediaQuery.size.height / 30;
    final buttonFontSize = mediaQuery.size.width / 14;

    Widget confirmButton() => ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 20,
                mediaQuery.size.height / 150),
            child: Text(
              "confirmar".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.white),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: () async {
          updateInformation(context);
        });

    Widget bodyContainer() => Container(
          decoration: BoxDecoration(
              color: Color(0xffFF8A00),
              borderRadius: BorderRadius.circular(10)),
          width: containerWidth,
          child: Column(
            children: [
              buildPadding(
                  confirmButton(), topAndBottomPadding, topAndBottomPadding)
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
                  Navigator.pushNamed(
                      context, AppRoutes.list_location_profiles);
                },
                icon:
                    Icon(Icons.chevron_left, size: mediaQuery.size.width / 10),
              ),
              title: Text(
                "Editar Informações",
                style: GoogleFonts.anton(
                    fontSize: mediaQuery.size.width / 14, color: Colors.white),
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: buildPadding(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [bodyContainer()],
                    ),
                    topAndBottomPadding,
                    topAndBottomPadding),
              ),
            )));
  }
}
