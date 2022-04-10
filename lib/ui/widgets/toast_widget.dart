import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class FlutterToast {
  static showToast(String data, {Color? color}) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor: color ?? HexColor('#46B04A'),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
