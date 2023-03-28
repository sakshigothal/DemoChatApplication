import 'package:demo_chat_application/Controller/login_controller.dart';
import 'package:demo_chat_application/View/chat_screen.dart';
import 'package:demo_chat_application/View/login_screen.dart';
import 'package:demo_chat_application/View/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  final loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            Container(
              width: 50,
              height: 50,
              color: Colors.red,
              child: CircularProgressIndicator(color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
  void checkSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('here is on splash screen--->${prefs.getString('key')}');
    if(prefs.getString('key') != null ){
      if(prefs.getString('key') == 'YHj8Ys7eQEQagrxamVhmWuasZUk1'){
          Get.to(UserListScreen());
      }else{
        Get.to(const ChatScreen());
      }
    }else{
      Get.to(const LoginScreen());
    }
  }

}
