import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeBox extends StatelessWidget {
  final String title;
  const NoticeBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(
              7,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(120),
            ),
            height: ScreenUtil().setHeight(2),
            width: ScreenUtil().setWidth(
              2,
            ),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(
            6,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(
              255,
              64,
              64,
              64,
            ),
            fontSize: ScreenUtil().setSp(
              12,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
