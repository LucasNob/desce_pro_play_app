import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String home_login = '/home_login';

  static Map<String, WidgetBuilder> define() {
    return {
      home_login: (context) => HomeLoginScreen(),
    };
  }
}