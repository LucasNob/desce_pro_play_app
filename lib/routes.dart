import 'package:desce_pro_play_app/views/email_verification_screen.dart';
import 'package:desce_pro_play_app/views/forget_password_email_screen.dart';
import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:desce_pro_play_app/views/register_screen.dart';
import 'package:desce_pro_play_app/views/register_sports_screen.dart';
import 'package:desce_pro_play_app/views/user_profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String home_login = '/home_login';
  static const String register = '/register';
  static const String register_sports = '/register_sports';
  static const String forget_password_email = '/forget_password_email';
  static const String forget_password = '/forget_password';
  static const String user_profile = '/user_profile';
  static const String email_verification = '/email_verification';

  static Map<String, WidgetBuilder> define() {
    return {
      home_login: (context) => HomeLoginScreen(),
      register: (context) => RegisterScreen(),
      register_sports: (context) => RegisterSportsScreen(),
      forget_password_email: (context) => ForgetPasswordEmailScreen(),
      user_profile: (context) => UserProfileScreen(),
      email_verification: (context) => EmailVerificationScreen(),
    };
  }
}
