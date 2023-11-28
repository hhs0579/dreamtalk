import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:intl/intl.dart';


class ChattingRoomVo {
  String otherUserId;
  String lastMessage;
  DateTime lastCreateDt;
  int otherUnReadCnt;

  ChattingRoomVo({
    required this.otherUserId,
    required this.lastMessage,
    required this.lastCreateDt,
    required this.otherUnReadCnt,
  });

  String get createDtStr => Utils.isSameDay(DateTime.now(), lastCreateDt)
      ? DateFormat('HH:mm').format(lastCreateDt)
      : DateFormat('MM-dd HH:mm').format(lastCreateDt);
}