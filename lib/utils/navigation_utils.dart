import 'package:flutter/material.dart';

class NavigationHelper {
  NavigationHelper._();

  /// Normal push on the current navigator (keeps nested navs).
  static Future<T?> push<T>(BuildContext context, Widget destination) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  /// Push onto the root navigator so the pushed page covers app chrome
  /// (bottom navigation bars, parent scaffold, etc).
  static Future<T?> pushFullScreen<T>(BuildContext context, Widget destination) {
    return Navigator.of(context, rootNavigator: true).push<T>(
      MaterialPageRoute(builder: (_) => destination, fullscreenDialog: false),
    );
  }

  /// Replace the current route on the current navigator.
  static Future<T?> replacePush<T>(BuildContext context, Widget destination) {
    return Navigator.of(context).pushReplacement<T, T>(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  /// Replace on the ROOT navigator (covering app chrome).
  static Future<T?> replacePushFullScreen<T>(BuildContext context, Widget destination) {
    return Navigator.of(context, rootNavigator: true).pushReplacement<T, T>(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  /// Push and clear entire navigation stack (current navigator).
  static Future<T?> pushAndClearStack<T>(BuildContext context, Widget destination) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => destination),
          (Route<dynamic> route) => false,
    );
  }

  /// Push and clear entire stack on the root navigator.
  static Future<T?> pushAndClearStackFullScreen<T>(BuildContext context, Widget destination) {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => destination),
          (Route<dynamic> route) => false,
    );
  }

  /// Pop current route.
  static void pop<T extends Object?>(BuildContext context, [ T? result ]) {
    Navigator.of(context).pop<T>(result);
  }
}
