import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final bool isLoading;
  final Color? color;
  final double size;
  final double paddingLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final String? widgetType;
  final bool isCenter;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const Loading({Key? key,
    this.isLoading = true,
    this.color,
    this.size = 50,
    this.paddingLeft = 0,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingBottom = 0,
    this.widgetType,
    this.isCenter = true,
    this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: padding ?? EdgeInsets.only(left: paddingLeft, top: paddingTop, right: paddingRight, bottom: paddingBottom),
        child: isCenter ? Center(
          child: _loadingWidget(),
        ) : _loadingWidget(),
      );
    } else if (child != null) {
      return child!;
    } else {
      return Container();
    }
  }

  Widget _loadingWidget() {
    if (widgetType != null && widgetType == 'threeArchedCircle') {
      return LoadingAnimationWidget.threeArchedCircle(
        color: color ?? const Color.fromRGBO(117, 81, 233, 1),
        size: size,
      );
    } else if (widgetType != null && widgetType == 'fallingDot') {
      return LoadingAnimationWidget.fallingDot(
        color: color ?? const Color.fromRGBO(117, 81, 233, 1),
        size: size,
      );
    } else {
      return LoadingAnimationWidget.hexagonDots(
        color: color ?? const Color.fromRGBO(117, 81, 233, 1),
        size: size,
      );
    }
  }
}