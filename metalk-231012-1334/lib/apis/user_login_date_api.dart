import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_login_date_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';

class UserLoginDateApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('userLoginDates');

  static Future<List<UserLoginDateVo>> getUserLoginDatesByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _ref.where('userId', isEqualTo: userId).get();
    return List<UserLoginDateVo>.from(querySnapshot.docs.map((e) => UserLoginDateVo.fromQueryDocumentSnapshot(e)));
  }

  static Future<UserLoginDateVo> addUserLoginDateByToday({
    required String userId,
  }) async {
    DocumentReference doc = await _ref.add(UserLoginDateVo(
      id: '0',
      userId: userId,
      dt: DateTime.now(),
    ).toMap());
    return UserLoginDateVo.fromQueryDocumentSnapshot(await doc.get());
  }
}