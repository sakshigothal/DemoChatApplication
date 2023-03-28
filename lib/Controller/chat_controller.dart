import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/firestore_constants.dart';
import '../models/message_chat.dart';

class ChatController extends GetxController{
  TextEditingController msgController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxString chatUser = ''.obs;

  Stream<QuerySnapshot> getChatStream() {
    // SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc('SwKUrwg0Gua2LsM7gfuSNGMakhf2')
        .collection('SwKUrwg0Gua2LsM7gfuSNGMakhf2')
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();
  }

  void sendMessage(String content,String currentUserId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentReference documentReference = firebaseFirestore.collection(
        FirestoreConstants.pathMessageCollection).doc(prefs.getString('chatUser')).collection(prefs.getString('chatUser')!).
    doc(DateTime.now().millisecondsSinceEpoch.toString());

    print('message path---->${FirestoreConstants.pathMessageCollection}');

    MessageChat messageChat = MessageChat(idTo: prefs.getString('key').toString(),
      idFrom: 'YHj8Ys7eQEQagrxamVhmWuasZUk1',
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: prefs.getString(FirestoreConstants.nickname) == 'admin@gmail.com' ? 1 : 0,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }
}