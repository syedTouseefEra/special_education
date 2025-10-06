
import 'package:flutter/material.dart';

class NavigationHelper {
  static void push(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void replacePush(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void pushAndClearStack(BuildContext context, Widget destination) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
          (Route<dynamic> route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

}
