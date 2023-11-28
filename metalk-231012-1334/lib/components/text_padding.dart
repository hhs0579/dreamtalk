import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class TextPadding extends StatelessWidget {
  double top;
  double right;
  double bottom;
  double left;
  String textContent;
  String? fontFamily;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  TextOverflow? overflow;
  TextAlign? textAlign;
  int? maxLines;
  bool? softWrap;
  TextDecoration? decoration;
  EdgeInsetsGeometry? padding;
  double? height;
  double? letterSpacing;
  TextDecorationStyle? decorationStyle;
  Color? decorationColor;
  double? decorationThickness;

  TextPadding(this.textContent, {Key? key,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.fontFamily,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.overflow,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.decoration,
    this.padding,
    this.height,
    this.letterSpacing,
    this.decorationStyle,
    this.decorationColor,
    this.decorationThickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      child: Text(
        textContent ?? '',
        softWrap: softWrap,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize ?? 16,
          color: color ?? HexColor('#1C1C1C'),
          decoration: decoration,
          height: height,
          letterSpacing: letterSpacing,
          decorationStyle: decorationStyle,
          decorationColor: decorationColor,
          decorationThickness: decorationThickness,
        ),
      ),
    );
  }
}