import 'package:flutter_metalk/model/user_coin_vo.dart';

class UserLoginDateVo {
  String id;
  String userId;
  DateTime dt;

  UserLoginDateVo({
    required this.id,
    required this.userId,
    required this.dt,
  });

  factory UserLoginDateVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return UserLoginDateVo(
      id: snapshot.id,
      userId: json['userId'],
      dt: json['dt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'dt': dt,
  };

  DateTime get dtByDate => DateTime(dt.year, dt.month, dt.day);

  static int getMaxLoginDay(List<UserLoginDateVo> userLoginDateVoList) {
    List<DateTime> distinctDt = userLoginDateVoList.map((e) => e.dtByDate).toSet().toList();
    return distinctDt.length;
  }

  static int getMaxContinuous(List<UserLoginDateVo> userLoginDateVoList) {
    int maxCnt = 0;
    int curCnt = 0;

    List<DateTime> distinctDt = userLoginDateVoList.map((e) => e.dtByDate).toSet().toList();
    distinctDt.sort((a, b) => a.isBefore(b) ? -1 : 1);
    DateTime? beforeDt;

    for (UserLoginDateVo itemVo in userLoginDateVoList) {
      DateTime curDt = itemVo.dtByDate;
      bool isContinuous = beforeDt == null || beforeDt.difference(curDt).abs().inDays == 1;
      beforeDt = curDt;

      if (isContinuous) {
        curCnt++;
      } else {
        curCnt = 0;
      }

      if (curCnt > maxCnt) {
        maxCnt = curCnt;
      }
    }


    return maxCnt;
  }
}