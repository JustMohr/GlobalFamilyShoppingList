import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gloabal_shopping_list/ActivityPage.dart';
import 'package:gloabal_shopping_list/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final String? loginID = prefs.getString('userID_SharedPrefs');

  final bool isUserExist = await DatabaseService(loginID!).isUserExists();

  runApp(MyApp(loginID, isUserExist));
}

class MyApp extends StatelessWidget {

  final String? loginID;
  final bool isUserExist;
  MyApp(this.loginID, this.isUserExist);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (loginID != null && isUserExist) ? ActivityPage(loginID!) : LoginPage()
    );
  }
}