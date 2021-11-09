import 'package:desce_pro_play_app/routes.dart';
import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:desce_pro_play_app/views/register_location_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desce Pro Play',
      routes: AppRoutes.define(),
      // alterar antes de subir a versão final
      home: RegisterLocationScreen(),
    );
  }
}
