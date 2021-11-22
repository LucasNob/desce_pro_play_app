import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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

  File? image;

  Future pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imagetemporary = File(image.path);
      setState(() => this.image = imagetemporary);
    } on PlatformException catch (e) {
      print('Erro ao selecionar imagem');
    }
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
      return IconButton(
        icon: Icon(Icons.home),
        onPressed: () => pickimage(),
        iconSize: 80,
        padding: EdgeInsets.zero,
      );
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