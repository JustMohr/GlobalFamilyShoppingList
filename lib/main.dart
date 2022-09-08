import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: (loginID != null)? Text('no data') : LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('join group'),
                onPressed: (){},
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              ElevatedButton(
                child: Text('create new group'),
                onPressed: () async{
                  final docUser = FirebaseFirestore.instance.collection('collection').doc();
                  await
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget newGroupButton(){

    return Column(
      children: [
        OutlinedButton(
          child: Text('create new group'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith( (state)=> Colors.red),
          ),
          onPressed: (){},
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('id:'), SizedBox(width: 10,), Icon(Icons.content_copy)],),
        ElevatedButton(
          child: Icon(Icons.check_sharp),
          onPressed: (){},
        )
      ]
    );
  }


}
