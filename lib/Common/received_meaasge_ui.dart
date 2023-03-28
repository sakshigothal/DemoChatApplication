import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomReceivedMessageUI extends StatelessWidget {

  final String receivedMsgTxt;
  const CustomReceivedMessageUI({
    Key? key,
    required this.receivedMsgTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receivedMsgTxtGroup = Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*CircleAvatar(
                radius: 20.r,
                backgroundImage: const NetworkImage(
                    'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg')
            ),*/
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text('John Doe'),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius:  BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      receivedMsgTxt,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));

    return Padding(
      padding: EdgeInsets.only(right: 45, left: 15, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          receivedMsgTxtGroup,
        ],
      ),
    );
  }
}