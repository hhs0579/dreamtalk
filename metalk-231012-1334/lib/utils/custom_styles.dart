import 'package:flutter/material.dart';

class CustomStyles {
  static ButtonStyle textButtonZeroSize({
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: padding ?? EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }
}