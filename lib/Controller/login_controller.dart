import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/firestore_constants.dart';
import '../models/user_chat.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class LoginController extends GetxController{
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  RxBool loginDone = false.obs;

  Status status = Status.uninitialized;


  Future<bool> handleSignIn() async {
    status = Status.authenticating;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstants.nickname: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: 'Admin'
          });

          // Write data to local storage
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          print('firebase user login id--->${prefs.getString(FirestoreConstants.id)}');
          await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
          await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstants.id, userChat.id);
          print('firebase user login id--->${prefs.getString(FirestoreConstants.id)}');
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        }
        status = Status.authenticated;
        return true;
      } else {
        status = Status.authenticateError;
        return false;
      }
    } else {
      status = Status.authenticateCanceled;
      return false;
    }
  }

  void handleException() {
    status = Status.authenticateException;
  }

  Future<bool> signInAnonymously() async{
    // UserCredential user = await
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('get string from sharedpreference --->${prefs.getString(FirestoreConstants.id)}');
    if(prefs.getString(FirestoreConstants.id) == 'id'){
      firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text);
    }

    // firebaseAuth.createUserWithEmailAndPassword(email: userName.text, password: password.text);
    prefs.clear();
    User? user = (await firebaseAuth.signInWithEmailAndPassword(email: email.text, password: password.text)).user;
    loginDone.value = true;
      if (user != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: user.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;

        if (documents.isEmpty) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(user.uid).set({
            FirestoreConstants.nickname: userName.text,
            FirestoreConstants.id: user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: 'Admin',
            'email' : user.email
          });
          loginDone.value = false;

          // Write data to local storage
          User? currentUser = user;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          prefs.setString('key', currentUser.uid);
          print('1--->${prefs.getString(FirestoreConstants.id)}');
          await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
          print('2--->${prefs.getString(FirestoreConstants.nickname)}');
          await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          print('3--->${prefs.getString(FirestoreConstants.photoUrl)}');
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstants.id, userChat.id);
          prefs.setString('key', userChat.id);
          print('11--->${prefs.getString(FirestoreConstants.id)}');
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          print('22--->${prefs.getString(FirestoreConstants.nickname)}');
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          print('33--->${prefs.getString(FirestoreConstants.photoUrl)}');
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          print('44--->${prefs.getString(FirestoreConstants.aboutMe)}');
        }
        status = Status.authenticated;
        return true;
      } else {
        status = Status.authenticateError;
        return false;
      }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }
}