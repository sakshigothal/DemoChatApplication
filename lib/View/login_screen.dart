import 'package:demo_chat_application/Controller/login_controller.dart';
import 'package:demo_chat_application/View/user_list_screen.dart';
import 'package:demo_chat_application/View/utility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/firestore_constants.dart';
import 'chat_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    checkVerifiedUser();
  }

  checkVerifiedUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(FirestoreConstants.id) != null ? ChatScreen() : LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Login Screen')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your nickname'
                ),
                  controller: loginController.userName),
              const SizedBox(height: 20),
              TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your email'
                  ),
                  controller: loginController.email),
              const SizedBox(height: 20),
              TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your password'
                  ),
                  controller: loginController.password),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async{
                    showLoading(context);
                    await loginController.signInAnonymously().then((value)  {
                      if(value && loginController.email.text == 'admin@gmail.com'){
                        Get.offAll(UserListScreen());
                      }else{
                        Get.offAll(const ChatScreen());
                        loginController.loginDone.value = false;
                      }
                      loginController.userName.clear();
                      loginController.password.clear();
                      loginController.email.clear();
                    }).catchError((error, stackTrace) {
                      Get.back();
                      Fluttertoast.showToast(msg: error.toString());
                      // authProvider.handleException();
                    });
                    /*loginController.handleSignIn().then((isSuccess) {
                      if (isSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      }
                    });*/
                  },
                  child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
