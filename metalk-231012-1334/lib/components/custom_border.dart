import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomBorder extends StatelessWidget {
  const CustomBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: HexColor('#EEEEEE'),
          ),
          Container(
            width: double.infinity,
            height: 9,
            color: HexColor('#F5F5F5'),
          ),
        ],
      ),
    );
  }
}
