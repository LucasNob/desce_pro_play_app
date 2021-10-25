import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:desce_pro_play_app/views/register_screen.dart';
import 'package:desce_pro_play_app/views/register_sports_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String home_login = '/home_login';
  static const String register ='/register';
  static const String register_sports ='/register_sports';

  static Map<String, WidgetBuilder> define() {
    return {
      home_login: (context) => HomeLoginScreen(),
      register: (context) => RegisterScreen(),
      register_sports: (context) => RegisterSportsScreen(),
    };
  }
}