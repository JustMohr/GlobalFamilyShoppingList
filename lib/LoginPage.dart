import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloabal_shopping_list/ActivityPage.dart';
import 'package:gloabal_shopping_list/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController textEditingController = TextEditingController();

  bool isJoinClicked = false;
  bool isNewGroupClicked = false;

  late String groupID;

  @override
  Widget build(BuildContext context) {

    final bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if(isJoinClicked)...[
              Header('Gruppe beitreten', isKeyboard),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: textEditingController,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                            isDense: true
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    ElevatedButton(
                        child: Icon(Icons.check_sharp),
                        onPressed: joinGroupLogic
                    ),
                    ElevatedButton(
                      child: Text('abbrechen'),
                      onPressed: ()=> setState(() {
                        isJoinClicked = false;
                        isNewGroupClicked = false;
                      }),
                    ),
                  ],
                ),
              ),
            ]else if(isNewGroupClicked)...[
              Header('neue Gruppe erstellen?', isKeyboard),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text('ID:  $groupID'),
                      SizedBox(width: 15,),
                      InkWell(child: Icon(Icons.content_copy), onTap: (){
                        Clipboard.setData(ClipboardData(text: '$groupID'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("ID In Zwischenablage kopiert"),
                        ));
                      },)
                    ],),
                    SizedBox(height: 25,),
                    ElevatedButton(
                      child: Icon(Icons.check_sharp),
                      onPressed: createRoomLogic,
                    ),
                    ElevatedButton(
                      child: Text('abbrechen'),
                      onPressed: ()=> setState(() {
                        isJoinClicked = false;
                        isNewGroupClicked = false;
                      }),
                    ),
                  ],
                ),
              ),
            ]else...[
              Header('shopping list', isKeyboard),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('Gruppe beitreten'),
                      onPressed: ()=> setState(() {
                        isJoinClicked = true;
                        isNewGroupClicked = false;
                      }),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                    ElevatedButton(
                        child: Text('neue Gruppe erstellen'),
                        onPressed: ()async {
                          groupID = await DatabaseService.generateNewGroupID();

                          setState(() {
                            isNewGroupClicked = true;
                            isJoinClicked = false;
                          });
                        }
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget Header(String title, bool isKeyboard){
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          (isKeyboard == false)? SizedBox(height: MediaQuery.of(context).size.height * 0.1,) : SizedBox(height: 20,),
          Text(
            title,
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }

  void joinGroupLogic() async{

    groupID = textEditingController.text;

    if(groupID.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gültige ID eingeben!'),
      ));
      return;
    }
    if(await Connectivity().checkConnectivity() == ConnectivityResult.none){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Überprüfe deine Internetverbindung!'),
      ));
      return;
    }

    FocusScope.of(context).requestFocus(new FocusNode());

    if(await DatabaseService(groupID).checkIfUserExists()){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userID_SharedPrefs', textEditingController.text);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ActivityPage(groupID)));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler, Überprüfe die ID!'),
      ));
    }

  }

  void createRoomLogic() async{

    if(await Connectivity().checkConnectivity() == ConnectivityResult.none){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Überprüfe deine Internetverbindung!'),
      ));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID_SharedPrefs', groupID);
    print('object');
    //loged in
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ActivityPage(groupID)));

  }
}
