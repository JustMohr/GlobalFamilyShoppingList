
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  String groupID;
  DatabaseService(this.groupID);
  
  final collectionReference = FirebaseFirestore.instance.collection('groups');

  static Future<String> generateNewGroupID() async{
    return FirebaseFirestore.instance.collection('groups').doc().id;
  }

  Future checkIfUserExists() async{
    if((await collectionReference.doc(groupID).get()).exists)
      return true;
    else
      return false;
  }

}