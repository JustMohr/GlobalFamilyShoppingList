import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gloabal_shopping_list/Database.dart';
import 'package:gloabal_shopping_list/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {

  String groupID;
  ActivityPage(this.groupID);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {

  late String id;
  late DatabaseService databaseService;

  @override
  void initState() {
    id = widget.groupID;
    databaseService = DatabaseService(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('title')),
      body: SafeArea(
        child: StreamBuilder<List>(
            stream: databaseService.getProducts(),
            builder: (context, snapshot){
              if(snapshot.hasData) {
                final list = snapshot.data!;
                return ListView(
                  children: list.map((element) => lsTile(element)).toList(),
                );
              }else{
                return CircularProgressIndicator();
              }

            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          databaseService.addProduct('vogel');
        },
      ),
    );
  }

  Widget lsTile(String product){
    return Dismissible(
      child: Card(
        child: ListTile(
          title: Text(product),
        ),
      ),

      key: Key(product),
      direction: DismissDirection.endToStart,
      dismissThresholds: {DismissDirection.endToStart: 0.75},
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      onDismissed: (direction) async {
        databaseService.removeProduct(product);
      }
    );
  }

}
