


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void alertToast(String message) {
  Fluttertoast.showToast(
    msg: message,
  );
}

void showSnackBar(String message,context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
