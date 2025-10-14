


import 'package:fluttertoast/fluttertoast.dart';

class AlertView {
  void alertToast(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }
}