import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../routes.dart';

class RegisterLocationScreen extends StatefulWidget {
  const RegisterLocationScreen({Key? key}) : super(key: key);

  @override
  _RegisterLocationScreenState createState() => _RegisterLocationScreenState();
}

class _RegisterLocationScreenState extends State<RegisterLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _taxaController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _contatoController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  TextEditingController _sobreController = TextEditingController();

  String dropdownValueSports = "Esportes Praticáveis: ";
  String dropdownValueQuadras = "Tipo de Quadras: ";
  bool privado = false;

  List<String> sports = [
    "Esportes Praticáveis: ",
    "Futebol",
    "Skate",
    "Basquete",
    "Football",
    "Vôlei",
    "Tênis",
    "Outro"
  ];
  List<String> quadras = [
    "Tipo de Quadras: ",
    "Grama",
    "Sintética",
    "Madeira",
    "Areia",
    "Outro"
  ];

  File? _locationImage;
  final picker = ImagePicker();

  Future uploadImageToFirebase() async {
    String fileName = basename(_locationImage!.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference firebaseStorageRef =
        storage.ref().child('location-images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_locationImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => newLocationData(value));
  }

  Future pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _locationImage = File(pickedFile!.path);
        //uploadImageToFirebase();
      });
    } on PlatformException catch (e) {
      print("Falha ao escolher foto: $e");
    }
  }

  void newLocationData(String imgURL) async {
    User? user = FirebaseAuth.instance.currentUser;
    String emailId = user!.email.toString();
    print(_enderecoController.text);
    List<Location> locations =
        await locationFromAddress(_enderecoController.text);
    print(_enderecoController.text);
    CollectionReference userdata =
        FirebaseFirestore.instance.collection('locationdata');
    await userdata.doc(_nameController.text).set({
      //criação de id especifico ao local?
      'name': _nameController.text,
      'fee': _taxaController.text,
      'adress': _enderecoController.text,
      'cep': _cepController.text,
      'sports': dropdownValueSports,
      'court_type': dropdownValueQuadras,
      'about': _sobreController.text,
      'created_by': emailId,
      'image_url': imgURL,
      'latitude': locations[0].latitude,
      'longitude': locations[0].longitude,
      'users': []
    });
  }

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

    void _showErrorSnack(String error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }

    Widget textField(
        TextEditingController controller, String nome, double width) {
      return Material(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: mediaQuery.size.width / width,
              child: TextFormField(
                controller: controller,
                maxLines: 1,
                style: GoogleFonts.anton(
                    fontSize: fieldFontSize, color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: nome,
                ),
              ),
            ),
          ));
    }

    Widget checkboxLocation() {
      return Checkbox(
          value: privado,
          checkColor: Colors.white,
          activeColor: Colors.black54,
          onChanged: (bool? value) {
            setState(() {
              privado = value!;
            });
          });
    }

    Widget buttonImage() {
      return Material(
          child: _locationImage != null
              ? Image.file(
                  _locationImage!,
                  width: mediaQuery.size.width / 2.5,
                  height: mediaQuery.size.height / 4.75,
                  fit: BoxFit.cover,
                )
              : IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => pickImage(),
                  iconSize: 80,
                  padding: EdgeInsets.zero,
                ));
    }

    Widget dropdownField(double width, List<String> list, bool option) {
      return Material(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: mediaQuery.size.width / width,
              child: DropdownButton<String>(
                value: option ? dropdownValueSports : dropdownValueQuadras,
                isExpanded: true,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: GoogleFonts.anton(
                    color: Colors.white, fontSize: fieldFontSize),
                onChanged: (String? newValue) {
                  setState(() {
                    if (option) {
                      dropdownValueSports = newValue!;
                    } else {
                      dropdownValueQuadras = newValue!;
                    }
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black54)),
                  );
                }).toList(),
              ),
            ),
          ));
    }

    bool validaCamposVazios() {
      if (privado) {
        if (_taxaController.text.isEmpty ||
            _nameController.text.isEmpty ||
            _enderecoController.text.isEmpty ||
            _cepController.text.isEmpty ||
            _locationImage == null)
          return true;
        else
          return false;
      } else {
        if (_nameController.text.isEmpty ||
            _enderecoController.text.isEmpty ||
            _cepController.text.isEmpty ||
            _locationImage == null)
          return true;
        else
          return false;
      }
    }

    bool validaDropDownItem() {
      if (dropdownValueSports == "Esportes Praticáveis: " ||
          dropdownValueQuadras == "Tipo de Quadras: ")
        return true;
      else
        return false;
    }

    Widget completeButton() {
      return ElevatedButton(
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
              _showErrorSnack("Dados invalidos");
            } else if (validaDropDownItem()) {
              _showErrorSnack("Selecione os itens");
            } else {
              uploadImageToFirebase();
              Navigator.of(context).pop();
            }
          });
    }

    Widget registerContainer() {
      return Column(
        children: [
          buildTopPadding(0, buttonImage()),
          buildTopPadding(12, textField(_nameController, "Nome", 1.1)),
          buildTopPadding(12, textField(_enderecoController, "Endereço", 1.1)),
          buildTopPadding(12, textField(_cepController, "CEP", 1.1)),
          buildTopPadding(12, dropdownField(1.1, sports, true)),
          buildTopPadding(12, dropdownField(1.1, quadras, false)),
          buildTopPadding(12, textField(_sobreController, "Sobre", 1.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTopPadding(0, checkboxLocation()),
              buildTopPadding(
                  0,
                  Text(
                    "Privado",
                    style: GoogleFonts.anton(
                        color: Colors.black54, fontSize: fieldFontSize),
                  )),
            ],
          ),
          Visibility(
            child: buildTopPadding(
                5, textField(_taxaController, "Taxa de utilização", 1.1)),
            visible: privado,
          ),
          completeButton(),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.user_profile);
            },
            icon: Icon(Icons.chevron_left, size: mediaQuery.size.width / 8),
          ),
          centerTitle: true,
          title: Text(
            "Cadastro de Local",
            style: GoogleFonts.anton(
                fontSize: mediaQuery.size.width / 14, color: Colors.white),
          ),
          actions: [logo],
          backgroundColor: Color(0xffFF8A00),
        ),
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: mediaQuery.size.height / 12,
                    bottom: mediaQuery.size.height / 12),
                child: registerContainer())));
  }

  Padding buildTopPadding(double topPadding, Widget field) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: field,
    );
  }
}
