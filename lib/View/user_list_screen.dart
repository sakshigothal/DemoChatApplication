import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_application/Controller/login_controller.dart';
import 'package:demo_chat_application/View/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatelessWidget {
   UserListScreen({Key? key}) : super(key: key);

  CollectionReference reference = FirebaseFirestore.instance.collection('users');
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("User List"),
          ),
          body:
          // Obx(() => loginController.loginDone.value ?
          SingleChildScrollView(
            child: Center(
              child: StreamBuilder(
                  stream: reference.snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx,index){
                            // print('user list--->${snapshot.data!.docs.}');
                            Map data = snapshot.data!.docs[index].data() as Map;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: ()async{
                                  /*CollectionReference ref = FirebaseFirestore.instance.collection('messages').doc(data['id']).collection(data['id']);
                            print('chat details---->${ref.snapshots()}');
                            final QuerySnapshot<Map<String, dynamic>> questionsQuery =
                            await FirebaseFirestore.instance.collection("messages").doc(data['id']).collection(data['id']).get();
                            print('the data is --->${questionsQuery.docChanges.first.toString()}');*/
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('chatUser', data['id']);
                                  print('${data['id']}');
                                  Get.to(const ChatScreen(),arguments: {
                                    'chatUser' : data['nickname'].toString()
                                  });
                                },
                                child: data['email'] != 'admin@gmail.com' ?  Container(
                                    height: 50,
                                    width: 100,color: Colors.cyan,alignment: Alignment.centerLeft,
                                    child:  Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(data['nickname'].toString()),
                                    ),) : const SizedBox(),
                              ),
                            );

                          });
                    }else{
                      return const Center(
                        child: Text('no data found'),
                      );
                    }
                  }),
            ),
          )
              // :
          // Container(
          //   color: Colors.white.withOpacity(0.8),
          //   child: const Center(
          //     child: CircularProgressIndicator(
          //       color: Colors.green,
          //     ),
          //   ),
          // )
          // )
      ),
    );
  }
}
