


//custom dialog with height and width
import 'package:flutter/material.dart';

showLoading(context) {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.white,
    // barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            // Dialog background
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              /*whiteColor.withOpacity(0.5),*/
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ), // Dialog height
            child: Container(
                height: 120,
                width: 120,
                decoration:const  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    )),
                child: const CircularProgressIndicator()
            ),
          ),
        ),
      );
    },
  );
}

//custom text alignment from left
