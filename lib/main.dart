import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gloabal_shopping_list/ActivityPage.dart';
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

  runApp(MyApp(loginID));
}

class MyApp extends StatelessWidget {

  String? loginID;
  MyApp(this.loginID);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (loginID == null) ? LoginPage() : ActivityPage(loginID!),
    );
  }
}