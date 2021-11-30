import 'package:desce_pro_play_app/views/email_verification_screen.dart';
import 'package:desce_pro_play_app/views/forget_password_email_screen.dart';
import 'package:desce_pro_play_app/views/home_login_screen.dart';
import 'package:desce_pro_play_app/views/list_location_profiles_screen.dart';
import 'package:desce_pro_play_app/views/list_location_screen.dart';
import 'package:desce_pro_play_app/views/list_profiles_screen.dart';
import 'package:desce_pro_play_app/views/location_profile_screen.dart';
import 'package:desce_pro_play_app/views/register_location_screen.dart';
import 'package:desce_pro_play_app/views/register_users_screen.dart';
import 'package:desce_pro_play_app/views/register_sports_screen.dart';
import 'package:desce_pro_play_app/views/user_profile_screen.dart';
import 'package:desce_pro_play_app/views/other_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AppRoutes {
  AppRoutes._();

  static const String home_login = '/home_login';
  static const String register = '/register';
  static const String register_sports = '/register_sports';
  static const String forget_password_email = '/forget_password_email';
  static const String forget_password = '/forget_password';
  static const String register_location = '/register_location';
  static const String user_profile = '/user_profile';
  static const String other_user_profile = '/other_user_profile';
  static const String email_verification = '/email_verification';
  static const String list_location_profiles = '/list_location_profiles';
  static const String list_location = '/list_location';
  static const String list_profiles = '/list_profiles';
  static const String location_profile = '/location_profile';

  static Map<String, WidgetBuilder> define() {
    return {
      home_login: (context) => HomeLoginScreen(),
      register: (context) => RegisterScreen(),
      register_sports: (context) => RegisterSportsScreen(),
      forget_password_email: (context) => ForgetPasswordEmailScreen(),
      register_location: (context) => RegisterLocationScreen(),
      user_profile: (context) => UserProfileScreen(),
      email_verification: (context) => EmailVerificationScreen(),
      list_location_profiles: (context) => ListLocationProfilesScreen(),
      list_location: (context) => ListLocationScreen(),
      list_profiles: (context) => ListProfilesScreen(),
      location_profile: (context) => LocationProfileScreen(locationName: ''),
      other_user_profile: (context) => OtherUserProfileScreen(userEmail: ''),
    };
  }
}
