import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desce_pro_play_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  String _gender = "Masculino";
  int _radioId = 0;
  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final fieldFontSize = mediaQuery.size.width / 24;
    final buttonFontSize = mediaQuery.size.width / 14;
    final topAndBottomPadding = mediaQuery.size.height / 30;

    void _showErrorSnack(String error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }

    bool validateNumber(String value) {
      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(patttern);
      if (value.length == 0 || !regExp.hasMatch(value)) {
        return true;
      } else {
        return false;
      }
    }

    bool validateSenhasDiferentes() {
      if (_passwordController.text != _repasswordController.text)
        return true;
      else
        return false;
    }

    bool validaCamposVazios() {
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          pickedDate.toString().isEmpty ||
          _phoneNumberController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _repasswordController.text.isEmpty)
        return true;
      else
        return false;
    }

    bool validaCamposEspacos() {
      if (_firstNameController.text.trim() == "" ||
          _lastNameController.text.trim() == "" ||
          pickedDate.toString().trim() == "" ||
          _phoneNumberController.text.trim() == "" ||
          _emailController.text.trim() == "" ||
          _passwordController.text.trim() == "" ||
          _repasswordController.text.trim() == "")
        return true;
      else
        return false;
    }

    bool validaEmail() {
      bool _isValid = EmailValidator.validate(_emailController.text);
      if (_isValid)
        return false;
      else
        return true;
    }

    void newUserData() async {
      //User? user = FirebaseAuth.instance.currentUser;
      //String emailId = user!.email.toString();
      String emailId = _emailController.text;
      CollectionReference userdata =
          FirebaseFirestore.instance.collection('userdata');
      await userdata.doc(emailId).set({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'birth_date': DateFormat('dd-MM-yyyy').format(pickedDate!).toString(),
        'phone_number': _phoneNumberController.text,
        'user_gender': _gender,
        'image_url': '',
        'sports': []
      });
    }

    void newUser(String email, String password) async {
      String? errorCode;
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (error) {
        errorCode = error.code;
      }
      if (errorCode == null) {
        Navigator.of(context).pushNamed(AppRoutes.register_sports);
      } else
        _showErrorSnack(errorCode);
    }

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
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nome',
              ),
            ),
          ),
        ));

    final lastNameField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _lastNameController,
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Sobrenome',
              ),
            ),
          ),
        ));

    final birthDateField = Container(
      width: mediaQuery.size.width / 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: mediaQuery.size.width / 2,
                  height: mediaQuery.size.height / 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pickedDate == null
                            ? 'Data de Nascimento'
                            : DateFormat('dd-MM-yyyy')
                                .format(pickedDate!)
                                .toString(),
                        style: GoogleFonts.anton(
                            fontSize: fieldFontSize, color: Colors.white),
                      ),
                    ],
                  ))),
          MaterialButton(
            minWidth: mediaQuery.size.width / 8,
            height: mediaQuery.size.height / 16,
            color: Colors.orangeAccent,
            child: Icon(Icons.calendar_today, color: Colors.white),
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
                              color: Colors.black),
                        ))
                  ],
                ),
                Row(
                  children: [
                    new Radio(
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
                              color: Colors.black),
                        ))
                  ],
                ),
                Row(
                  children: [
                    new Radio(
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
                              color: Colors.black),
                        ))
                  ],
                )
              ],
            )));

    final phoneNumberField = Material(
        color: Colors.grey,
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
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Número de Celular',
              ),
            ),
          ),
        ));

    final emailField = Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            width: mediaQuery.size.width / 1.4,
            child: TextFormField(
              controller: _emailController,
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
              ),
            ),
          ),
        ));

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
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Senha',
              ),
            ),
          ),
        ));

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
              style: GoogleFonts.anton(
                  fontSize: fieldFontSize, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Digite novamente a Senha',
              ),
            ),
          ),
        ));

    final continueButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150,
                mediaQuery.size.width / 10,
                mediaQuery.size.height / 150),
            child: Text(
              "continuar".toUpperCase(),
              style: GoogleFonts.anton(
                  fontSize: buttonFontSize, color: Colors.black),
            )),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8A00)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ))),
        onPressed: () {
          if (validaCamposVazios()) {
            _showErrorSnack("Preencha os campos");
          } else if (validaCamposEspacos()) {
            _showErrorSnack("Dados inválidos");
          } else if (validateNumber(_phoneNumberController.text)) {
            _showErrorSnack("Formato de Telefone inválido");
          } else if (validaEmail()) {
            _showErrorSnack("Formato de E-mail inválido");
          } else if (validateSenhasDiferentes()) {
            _showErrorSnack("Senhas diferentes");
          } else {
            newUser(_emailController.text, _passwordController.text);
            newUserData();
          }
        });

    final registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildTopPadding(topAndBottomPadding, firstNameField),
        buildTopPadding(topAndBottomPadding, lastNameField),
        Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding, bottom: topAndBottomPadding),
            child: birthDateField),
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
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            buildTopPadding(topAndBottomPadding, logo),
            Padding(
                padding: EdgeInsets.only(top: topAndBottomPadding),
                child: registerFields),
            Padding(
                padding: EdgeInsets.only(
                    top: topAndBottomPadding, bottom: topAndBottomPadding),
                child: continueButton),
          ],
        ));

    return Scaffold(
        backgroundColor: Color(0xffFF8A00),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: mediaQuery.size.height / 12,
                    bottom: mediaQuery.size.height / 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    registerContainer,
                  ],
                ))));
  }

  Padding buildTopPadding(double topPadding, Material field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
