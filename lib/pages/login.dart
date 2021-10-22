
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
  return LoginPageState();
  }
}
class LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Desce pro Play - login"),
       centerTitle: true,
     ),
   );
  }


}