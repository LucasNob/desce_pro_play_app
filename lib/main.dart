import 'dart:ui';

import 'package:desce_pro_play_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _FbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FutureBuilder(
        future: _FbApp,
        builder:(context,snapshot){
          if(snapshot.hasError){
            print('Erro Firebase ${snapshot.error.toString()}');
            return Text("Erro Firebase");
          } else if (snapshot.hasData){
            return MyHomePage(title: "Desce pro play - main");
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Desce pro play - main',
            ),
          ],
        ),
      ),
    );
  }
}
