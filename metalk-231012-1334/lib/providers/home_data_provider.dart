import 'package:flutter/cupertino.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/model/filter_args.dart';
import 'package:flutter_metalk/model/user_vo.dart';

class HomeDataProvider with ChangeNotifier {
  List<UserVo> recentUserVoList = [];
  List<UserVo> hotRankUserVoList = [];
  List<UserVo> distanceUserVoList = [];
  List<UserVo> onlineUserVoList = [];

  Future<void> refreshData({
    required UserVo userVo,
    required FilterArgs filterArgs,
  }) async {
    recentUserVoList = await UserApi.getUsers(userVo,
      isOrderByCreateDt: true,
      ignoreUserVo: userVo,
      filterArgs: filterArgs,
      onlyOtherUserGender: userVo,
    );
    hotRankUserVoList = List<UserVo>.from(recentUserVoList);
    distanceUserVoList = List<UserVo>.from(recentUserVoList);
    distanceUserVoList.sort((a, b) => (a.distanceBetween ?? 0) > (b.distanceBetween ?? 0) ? 1 : -1);
    onlineUserVoList = List<UserVo>.from(recentUserVoList).where((userVo) => userVo.isOnline).toList();
    notifyListeners();
  }
}