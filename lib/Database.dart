
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  String groupID;
  DatabaseService(this.groupID);
  
  final collectionReference = FirebaseFirestore.instance.collection('groups');

  static Future<String> generateNewGroupID() async{
    return FirebaseFirestore.instance.collection('groups').doc().id;
  }

  Future isUserExists() async{
    if((await collectionReference.doc(groupID).get()).exists)
      return true;
    else
      return false;
  }

  void activateGroup(){
    final json = {
      'activate' : true,
      'list' : []
    };
    collectionReference.doc(groupID).set(json);
  }


  Future<void> addProduct(String product) async{

    Map<String, dynamic>? data = (await collectionReference.doc(groupID).get()).data();
    List list = data!['list'];
    list.add(product);

    data['list'] = list;
    collectionReference.doc(groupID).set(data);

  }

  /*Future<Stream<List<String>>> getProducts() async{



  }*/

}