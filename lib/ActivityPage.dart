import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloabal_shopping_list/Database.dart';
import 'package:gloabal_shopping_list/TutorialDialog.dart';

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
    TutorialDialog.tutorialCheck(context);
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
                          contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 5)
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *0.1,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 22,
                      icon: Icon(Icons.group_add,),
                      onPressed: showId,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *0.2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: ElevatedButton(
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.zero
                          ),
                          onPressed: addProduct,
                        )
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
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
                          return Center(child: CircularProgressIndicator());
                        }

                      }
                  ),
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

  void showId(){
    showDialog(
        context: context,
        builder: (BuildContext alertContext){
          return AlertDialog(
            title: Text('Deine Gruppen-ID lautet:', textAlign: TextAlign.center,),
            content: Text(id, textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: Text("kopieren"),
                onPressed: (){
                  Clipboard.setData(ClipboardData(text: '$id'));
                  Navigator.pop(alertContext);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("ID In Zwischenablage kopiert"),
                  ));
                },
              ),
              TextButton(
                child: Text("okay"),
                onPressed: () => Navigator.pop(alertContext)
              ),
            ],
          );
        }
    );
  }
}
