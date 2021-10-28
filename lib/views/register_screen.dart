import 'package:desce_pro_play_app/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterScreen>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  String _gender = "";
  int  _radioId = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    final logo = Material(
      color: Colors.transparent,
      child: Image.asset(
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.width / 1.5,
      ),
    );

    final firstNameField = Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Container(
          width: mediaQuery.size.width / 1.4,
          child: TextFormField(
            controller: _firstNameController,
            style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nome',
            ),
          ),
        ),
      )
    );

    final lastNameField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _lastNameController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Sobrenome',
              ),
            ),
          ),
        )
    );

    final birthDateField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _birthDateController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Data de Nascimento',
              ),
            ),
          ),
        )
    );

    final genderField = Material(
        color: Colors.transparent,
        child: Container(
            width: mediaQuery.size.width / 2,
            child: Column(
              children: [
                Row(
                  children: [
                    new Radio(
                        value: 0,
                        groupValue: _radioId,
                        onChanged:  (void newValue) {
                          setState(() {
                            _gender = "Masculino";
                            _radioId = 0;
                          });
                        }
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mediaQuery.size.width/15),
                      child: Text(
                        'Masculino',
                        style: GoogleFonts.anton(fontSize: fieldFontSize * 1.2, color: Colors.black),
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    new Radio(
                        value: 1,
                        groupValue: _radioId,
                        onChanged:  (void newValue) {
                          setState(() {
                            _gender = "Feminino";
                            _radioId = 1;
                          });
                        }
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: mediaQuery.size.width/15),
                        child: Text(
                          'Feminino',
                          style: GoogleFonts.anton(fontSize: fieldFontSize * 1.2, color: Colors.black),
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    new Radio(
                        value: 2,
                        groupValue: _radioId,
                        onChanged:  (void newValue) {
                          setState(() {
                            _gender = "Outro";
                            _radioId = 2;
                          });
                        }
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: mediaQuery.size.width/15),
                        child: Text(
                          'Outro',
                          style: GoogleFonts.anton(fontSize: fieldFontSize * 1.2, color: Colors.black),
                        )
                    )
                  ],
                )
              ],
            )
        )
    );

    final phoneNumberField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _phoneNumberController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Número de Celular',
              ),
            ),
          ),
        )
    );

    final emailField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _emailController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
              ),
            ),
          ),
        )
    );

    final passwordField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              obscureText: true,
              controller: _passwordController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Senha',
              ),
            ),
          ),
        )
    );


    final repasswordField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              obscureText: true,
              controller: _repasswordController,
              style: GoogleFonts.anton(fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Digite novamente a Senha',
              ),
            ),
          ),
        )
    );

    final continueButton = ElevatedButton(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              mediaQuery.size.width / 10,
              mediaQuery.size.height / 150,
              mediaQuery.size.width / 10,
              mediaQuery.size.height / 150),
          child: Text(
            "continuar".toUpperCase(),
            style: GoogleFonts.anton(fontSize: buttonFontSize, color: Colors.black),
          )
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
          )
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register_sports);
        }
    );

    final registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildTopPadding(topAndBottomPadding, firstNameField),
        buildTopPadding(topAndBottomPadding, lastNameField),
        buildTopPadding(topAndBottomPadding, birthDateField),
        buildTopPadding(topAndBottomPadding, genderField),
        buildTopPadding(topAndBottomPadding, phoneNumberField),
        buildTopPadding(topAndBottomPadding, emailField),
        buildTopPadding(topAndBottomPadding, passwordField),
        buildTopPadding(topAndBottomPadding, repasswordField)
      ],
    );

    final registerContainer = Container(
      width: mediaQuery.size.width / 1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: <Widget>[
          buildTopPadding(topAndBottomPadding, logo),
          Padding(
            padding: EdgeInsets.only(top: topAndBottomPadding),
            child: registerFields
          ),
          Padding(
              padding: EdgeInsets.only(top: topAndBottomPadding, bottom: topAndBottomPadding),
              child: continueButton
          ),
        ],
      )
    );

    return Scaffold(
      backgroundColor: Color(0xffFF8A00),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: mediaQuery.size.height / 12, bottom: mediaQuery.size.height / 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              registerContainer,
            ],
          )
        )
      )
    );
  }

  Padding buildTopPadding(double topPadding, Material field) {
    return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: field,
        );
  }
}