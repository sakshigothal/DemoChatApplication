import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_application/Controller/chat_controller.dart';
import 'package:demo_chat_application/View/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/received_meaasge_ui.dart';
import '../Common/send_message_ui.dart';
import '../Controller/login_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.put(ChatController());
  final loginController = Get.put(LoginController());
  CollectionReference? msgReference;

  @override
  void initState() {
    super.initState();
    firstCall();
  }

  void firstCall()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      msgReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(prefs.get('chatUser').toString())
          .collection(prefs.get('chatUser').toString());

    });
    if(prefs.getString('key') == 'YHj8Ys7eQEQagrxamVhmWuasZUk1'){
      print('checking for chat user---->${chatController.chatUser.value}-------${ Get.arguments['chatUser']}');
      chatController.chatUser.value = Get.arguments['chatUser'];
    }


  }






  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:   AppBar(
          title: Obx(() => chatController.chatUser.value.isNotEmpty ?
          Text(chatController.chatUser.value) :
          const Text('Admin')),
          actions: [IconButton(onPressed: ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            FirebaseAuth.instance.signOut();
            prefs.clear();
            Get.offAll(const LoginScreen());
          }, icon: const Icon(Icons.logout))],
        ),
          bottomSheet: Container(
            height: 64.h,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextFormField(
                    controller: chatController.msgController,
                    decoration: InputDecoration(
                      hintText: 'Please enter message',
                      enabled: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                      isDense: true,
                      prefixIconConstraints:
                      BoxConstraints(minHeight: 12.h, minWidth: 10.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                          borderSide:  const BorderSide(color: Color(0xffC28ACCFF), width: 1)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        borderSide: const BorderSide(color: Color(0xffC28ACCFF), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        borderSide: const BorderSide(color: Color(0xffC28ACCFF), width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        borderSide: const BorderSide(color: Color(0xffC28ACCFF), width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        borderSide: const BorderSide(color: Color(0xffc28accff), width: 1),
                      ),
                    ),
                  ),
                ),
                InkWell(
                    onTap: ()async{

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      chatController.sendMessage(chatController.msgController.text ,prefs.getString('key').toString());
                      print('chat screen firestore constant id--->${prefs.getString('key').toString()}');
                      chatController.msgController.clear();
                    },
                    child: SvgPicture.asset('assets/send icon.svg',colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),))
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: msgReference?.snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child:
                      ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount : snapshot.data!.docs.length,
                          itemBuilder: (ctx,index) {
                            Map data = snapshot.data!.docs[index].data() as Map;
                            return data['id'] != 'YHj8Ys7eQEQagrxamVhmWuasZUk1' ?
                            Padding(
                              padding:  EdgeInsets.only(bottom: index == (snapshot.data!.docs.length-1) ? 100 :0),
                              child: data['type'] == 0 ? CustomSendMessageUI(sendMsgTxt: data['content'].toString())
                                  : CustomReceivedMessageUI(receivedMsgTxt: data['content'].toString()) ,
                            ):
                            Padding(
                              padding:  EdgeInsets.only(bottom: index == (snapshot.data!.docs.length-1) ? 100 :0),
                              child: data['type'] == 1 ? CustomSendMessageUI(sendMsgTxt: data['content'].toString())
                                  : CustomReceivedMessageUI(receivedMsgTxt: data['content'].toString()) ,
                            );
                          }),

                    );
                    // });
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                            CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                }),
          )),
    );
  }
}

