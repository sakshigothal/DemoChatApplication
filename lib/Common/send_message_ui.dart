import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSendMessageUI extends StatelessWidget {

  final String sendMsgTxt;
  const CustomSendMessageUI({
    Key? key,
    required this.sendMsgTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sendMsgTxtGroup = Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('You'),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      sendMsgTxt,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ));

    return Padding(
      padding: EdgeInsets.only(right: 15, left: 45, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(height: 30,color: Colors.blue,),
          sendMsgTxtGroup,
        ],
      ),
    );
  }
}