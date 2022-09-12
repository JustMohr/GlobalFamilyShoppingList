
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

  Stream<List> getProducts() =>
      collectionReference.doc(groupID).snapshots().map((event) => event.data()?['list']);


  Future<void> addProduct(String product) =>
      collectionReference.doc(groupID).update({'list' : FieldValue.arrayUnion([product])});

  Future<void> removeProduct(String product) =>
      collectionReference.doc(groupID).update({'list' : FieldValue.arrayRemove([product])});

}