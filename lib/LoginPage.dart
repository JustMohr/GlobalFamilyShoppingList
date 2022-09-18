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
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
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
                            isDense: true,
                            hintText: 'ID',
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
                footer(
                    'Gebe die ID der Gruppe ein, der du beitreten möchtest.',
                    isKeyboard
                )
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
                footer(
                    'Die ID kann später noch eingesehen werden.',
                    isKeyboard
                )
              ]else...[
                Header('shoppingFamily', isKeyboard),
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
                footer(
                  'Tritt einer Gruppe bei oder erstelle eine neue.',
                  isKeyboard
                )
              ],
            ],
          ),
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
  
  Widget footer(String text, bool isKeyboard){

    final space = MediaQuery.of(context).size.width * 0.2;

    if(isKeyboard)
      return Container();
    else 
      return SizedBox(
        height: double.infinity,
        width:  double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(space, 0, space, 0) ,child: Text(text, textAlign: TextAlign.center)),
            SizedBox(height: 20,)
          ],
        ),
      );
  }

  void joinGroupLogic() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    groupID = textEditingController.text;

    if(groupID.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gültige ID eingeben!'),
      ));
      Navigator.pop(context);
      return;
    }
    if(await Connectivity().checkConnectivity() == ConnectivityResult.none){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Überprüfe deine Internetverbindung!'),
      ));
      Navigator.pop(context);
      return;
    }

    FocusScope.of(context).requestFocus(new FocusNode());

    if(await DatabaseService(groupID).isUserExists()){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userID_SharedPrefs', textEditingController.text);

      Navigator.pop(context);//remove showDialog
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ActivityPage(groupID)));
      
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler, Überprüfe die ID!'),
      ));
      Navigator.pop(context);
    }

  }

  void createRoomLogic() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    if(await Connectivity().checkConnectivity() == ConnectivityResult.none){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Überprüfe deine Internetverbindung!'),
      ));
      Navigator.pop(context);
      return;
    }

    DatabaseService databaseService = DatabaseService(groupID);
    if(await databaseService.isUserExists()){
      groupID = await DatabaseService.generateNewGroupID();
      setState(() {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler, veruche es erneut'),
        ));
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID_SharedPrefs', groupID);

    databaseService.activateGroup();
    //loged in
    Navigator.pop(context);//remove showDialog
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ActivityPage(groupID)));

  }
}
