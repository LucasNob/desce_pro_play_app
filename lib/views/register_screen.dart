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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // Responsividade

    final fontSize = mediaQuery.size.width / 12;
    final topPadding = mediaQuery.size.height / 30;

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
            style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
            width: mediaQuery.size.width / 1.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Radio(
                    value: 0,
                    groupValue: 0,
                    onChanged:  (void newValue) {
                      setState(() {
                        _gender = "Masculino";
                      });
                    }
                ),
                Text(
                  'Masculino',
                  style: GoogleFonts.anton(fontSize: fontSize/3, color: Colors.black),
                ),
                new Radio(
                    value: 1,
                    groupValue: 1,
                    onChanged:  (void newValue) {
                      setState(() {
                        _gender = "Feminino";
                      });
                    }
                ),
                Text(
                  'Feminino',
                  style: GoogleFonts.anton(fontSize: fontSize/3, color: Colors.black),
                ),
                new Radio(
                    value: 2,
                    groupValue: 2,
                    onChanged:  (void newValue) {
                      setState(() {
                        _gender = "Outro";
                      });
                    }
                ),
                Text(
                  'Outro',
                  style: GoogleFonts.anton(fontSize: fontSize/3, color: Colors.black),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
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
              style: GoogleFonts.anton(fontSize: fontSize/2, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Digite novamente a Senha',
              ),
            ),
          ),
        )
    );

    final logInButton = ElevatedButton(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              mediaQuery.size.width / 10,
              mediaQuery.size.height / 150,
              mediaQuery.size.width / 10,
              mediaQuery.size.height / 150),
          child: Text(
            "CONTINUAR",
            style: GoogleFonts.anton(fontSize: fontSize, color: Colors.black),
          )
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
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
        buildTopPadding(topPadding, firstNameField),
        buildTopPadding(topPadding, lastNameField),
        buildTopPadding(topPadding, birthDateField),
        buildTopPadding(topPadding, genderField),
        buildTopPadding(topPadding, phoneNumberField),
        buildTopPadding(topPadding, emailField),
        buildTopPadding(topPadding, passwordField),
        buildTopPadding(topPadding, repasswordField)
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
          logo,
          Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 60),
            child: registerFields
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 20, 0, mediaQuery.size.height / 20),
              child: logInButton
          ),
        ],
      )
    );

    return Scaffold(
      backgroundColor: Color(0xffFF8A00),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height / 12, 0, mediaQuery.size.height / 12),
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