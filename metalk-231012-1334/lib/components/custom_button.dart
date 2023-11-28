import 'package:flutter/material.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: CustomStyles.textButtonZeroSize(),
      child: child,
    );
  }
}
