import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    id = widget.groupID;
    databaseService = DatabaseService(id);
    super.initState();
  }


  @override
  void dispose() {
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.1,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Produkt',
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *0.2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: ElevatedButton(
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: addProduct,
                        )
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                padding: (MediaQuery.of(context).viewInsets.bottom != 0)?
                EdgeInsets.fromLTRB(0, 10, 0, 0) : EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: StreamBuilder<List>(
                    stream: databaseService.getProducts(),
                    builder: (context, snapshot){
                      if(snapshot.hasData) {
                        final list = snapshot.data!;
                        return (list.isEmpty || list==null) ?
                          Container():
                          ListView(
                          children: list.map((element) => lsTile(element)).toList(),
                        );
                      }else{
                        return CircularProgressIndicator();
                      }

                    }
                ),
              ),
            ),
            /*Container(
              width: double.infinity,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Gruppen ID einsehen'),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Widget lsTile(String product){
    return Dismissible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Card(
          child: ListTile(
            title: Text(product),
            //trailing: Row(children: [Icon(Icons.arrow_back), Icon(Icons.delete)],mainAxisSize: MainAxisSize.min,),
          ),
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

  void addProduct() async{
    String input = _textController.text;

    if(input.isEmpty)
      return;

    _textController.clear();

    if(await databaseService.isAlreadyInList(input)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Produkt schon hinzugefügt"),
      ));
      return;
    }

    databaseService.addProduct(input);

  }

}
