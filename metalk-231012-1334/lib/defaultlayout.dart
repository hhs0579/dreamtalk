import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final AppBar? appbar;
  final String? title;

  const DefaultLayout({
    super.key,
    required this.child,
    this.appbar,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: renderAppBar(),
      body: child,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          title!,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
