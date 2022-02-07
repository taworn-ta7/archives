import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Pages {
  /// Switching current route.
  /// This function is for sub-pages only!
  static Future<T?> switchPage<T extends Object?>(
    BuildContext context,
    Widget widget, {
    Object? arguments,
  }) {
    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: widget,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  // ----------------------------------------------------------------------

  static const login = '/';
  static const dashboard = '/dashboard';
  static const sku = '/sku';
  static const product = '/product';
}
