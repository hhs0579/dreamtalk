import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonUtils {
  static double getRateWidth(double val) {
    return ScreenUtil().setWidth(val * 72 / 25);
  }

  static double getRateHeight(double val) {
    return ScreenUtil().setHeight(val * 72 / 25);
  }

  static double getRateSP(double val) {
    return ScreenUtil().setSp(val * 72 / 25);
  }
}