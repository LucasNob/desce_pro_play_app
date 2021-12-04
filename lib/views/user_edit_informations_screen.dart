import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Material buildField(TextEditingController _controller, double _fontSize,
      double _fieldWidth, String _hint) {
    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: _fieldWidth,
            child: TextFormField(
              controller: _controller,
              style:
                  GoogleFonts.anton(fontSize: _fontSize, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hint,
                  hintStyle: TextStyle(color: Colors.orangeAccent)),
            ),
          ),
        ));
  }

  bool validateField(String field, String error, BuildContext context) {
    if (field.trim() != "")
      return true;
    else {
      _showErrorSnack(error + " possuí valor inválido.", context);
      return false;
    }
  }

  bool validateNumber(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);

    if (value.length == 0 || !regExp.hasMatch(value) || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final containerWidth = mediaQuery.size.width / 1.1;
    final fieldWidth = mediaQuery.size.width / 1.4;

    final topAndBottomPadding = mediaQuery.size.height / 30;

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;

    final firstNameField =
        buildField(_firstNameController, fieldFontSize, fieldWidth, "Nome");

    final lastNameField =
        buildField(_lastNameController, fieldFontSize, fieldWidth, "Sobrenome");

    final birthDateField = Container(
      width: mediaQuery.size.width / 1.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: mediaQuery.size.width / 1.8,
                  height: mediaQuery.size.height / 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      pickedDate == null
                          ? Text('Data de Nascimento',
                              style: GoogleFonts.anton(
                                  fontSize: fieldFontSize,
                                  color: Colors.orangeAccent))
                          : Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(pickedDate!)
                                  .toString(),
                              style: GoogleFonts.anton(
                                  fontSize: fieldFontSize,
                                  color: Colors.black)),
                    ],
                  ))),
          MaterialButton(
            minWidth: mediaQuery.size.width / 8,
            height: mediaQuery.size.height / 16,
            color: Colors.white,
            child: Icon(Icons.calendar_today, color: Colors.orangeAccent),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now())
                  .then((date) {
                setState(() {
                  pickedDate = date!;
                });
              });
            },
          ),
        ],
      ),
    );

    final phoneNumberField = Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _phoneNumberController,
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Número de Celular',
                  hintStyle: TextStyle(color: Colors.orangeAccent)),
            ),
          ),
        ));

    final genderField = Material(
        color: Colors.transparent,
        child: Container(
            width: mediaQuery.size.width / 2,
            child: Column(
              children: [
                Row(
                  children: [
                    new Radio(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: 0,
                        groupValue: _radioId,
                        onChanged: (void newValue) {
                          setState(() {
                            _gender = "Masculino";
                            _radioId = 0;
                          });
                        }),
                    Padding(
                        padding:
                            EdgeInsets.only(left: mediaQuery.size.width / 15),
                        child: Text(
                          'Masculino',
                          style: GoogleFonts.anton(
                              fontSize: fieldFontSize * 1.2,
                              color: Colors.white),
                        ))
                  ],
                ),
                Row(
                  children: [
                    new Radio(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: 1,
                        groupValue: _radioId,
                        onChanged: (void newValue) {
                          setState(() {
                            _gender = "Feminino";
                            _radioId = 1;
                          });
                        }),
                    Padding(
                        padding:
                            EdgeInsets.only(left: mediaQuery.size.width / 15),
                        child: Text(
                          'Feminino',
                          style: GoogleFonts.anton(
                              fontSize: fieldFontSize * 1.2,
                              color: Colors.white),
                        ))
                  ],
                ),
                Row(
                  children: [
                    new Radio(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: 2,
                        groupValue: _radioId,
                        onChanged: (void newValue) {
                          setState(() {
                            _gender = "Outro";
                            _radioId = 2;
                          });
                        }),
                    Padding(
                        padding:
                            EdgeInsets.only(left: mediaQuery.size.width / 15),
                        child: Text(
                          'Outro',
                          style: GoogleFonts.anton(
                              fontSize: fieldFontSize * 1.2,
                              color: Colors.white),
                        ))
                  ],
                )
              ],
            )));

    final confirmButton = ElevatedButton(
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
          if (validateField(_firstNameController.text, "Nome", context) &&
              validateField(_lastNameController.text, "Sobrenome", context) &&
              validateNumber(_phoneNumberController.text)) {
            if (pickedDate != null) {
              updateInformation(context);
            } else {
              _showErrorSnack("Selecione uma data.", context);
            }
          }
        });

    Widget bodyContainer() => Container(
          decoration: BoxDecoration(
              color: Color(0xffFF8A00),
              borderRadius: BorderRadius.circular(10)),
          width: containerWidth,
          child: Column(
            children: [
              buildPadding(firstNameField, topAndBottomPadding, 0),
              buildPadding(lastNameField, topAndBottomPadding, 0),
              buildPadding(birthDateField, topAndBottomPadding, 0),
              buildPadding(phoneNumberField, topAndBottomPadding, 0),
              buildPadding(genderField, topAndBottomPadding, 0),
              buildPadding(
                  confirmButton, topAndBottomPadding, topAndBottomPadding)
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
                  Navigator.pushNamed(context, AppRoutes.user_profile);
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
