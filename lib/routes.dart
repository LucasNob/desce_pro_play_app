import 'package:desce_pro_play_app/views/forget_password_email_screen.dart';
import 'package:desce_pro_play_app/views/forget_password_screen.dart';
import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:desce_pro_play_app/views/register_screen.dart';
import 'package:desce_pro_play_app/views/register_sports_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String home_login = '/home_login';
  static const String register ='/register';
  static const String register_sports ='/register_sports';
  static const String forget_password_email ='/forget_password_email';
  static const String forget_password ='/forget_password';

  static Map<String, WidgetBuilder> define() {
    return {
      home_login: (context) => HomeLoginScreen(),
      register: (context) => RegisterScreen(),
      register_sports: (context) => RegisterSportsScreen(),
      forget_password_email: (context) => ForgetPasswordEmailScreen(),
      forget_password: (context) => ForgetPasswordScreen(),
    };
  }
}