import 'package:flutter/material.dart';
import 'package:gloabal_shopping_list/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {

  String groupID;
  ActivityPage(this.groupID);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('title')),
      body: SafeArea(
        child: ElevatedButton(
          child: Text(widget.groupID),
          onPressed: ()async{
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('userID_SharedPrefs');

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

          }
        ),
      ),
    );
  }
}