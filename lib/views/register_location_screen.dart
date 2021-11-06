import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String dropdownValueSports = "Selecionar";
  String dropdownValueQuadras = "Selecionar";
  List<String> sports = [
    "Selecionar",
    "Futebol",
    "Skate",
    "Basquete",
    "Football",
    "Vôlei",
    "Tênis",
    "Outro"
  ];
  List<String> quadras = [
    "Selecionar",
    "Grama",
    "Sintética",
    "Madeira",
    "Areia",
    "Outro"
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
        "lib/resources/logo.png",
        height: mediaQuery.size.height / 4,
        width: mediaQuery.size.width / 1.5,
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

    Widget dropdownField(
        double width, List<String> list, String dropdownValue) {
      return Material(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: mediaQuery.size.width / width,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: GoogleFonts.anton(
                    color: Colors.white, fontSize: fieldFontSize),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTopPadding(10, textField(_nameController, "Nome", 3)),
              buildTopPadding(
                  10, textField(_taxaController, "Taxa de Entrada", 3)),
            ],
          ),
          buildTopPadding(20, textField(_enderecoController, "Endereço", 1.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTopPadding(20, textField(_contatoController, "Contato", 3)),
              buildTopPadding(20, textField(_cepController, "CEP", 3)),
            ],
          ),
          buildTopPadding(10, dropdownField(1.1, sports, dropdownValueSports)),
          buildTopPadding(
              10, dropdownField(1.1, quadras, dropdownValueQuadras)),
          buildTopPadding(10, textField(_sobreController, "Sobre", 1.1)),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: Image.asset("lib/resources/logoperfect.png",
              height: mediaQuery.size.height / 4,
              width: mediaQuery.size.width / 1.5),
          title: Text(
            "Cadastro de Local",
          ),
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
