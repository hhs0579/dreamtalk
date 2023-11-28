import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/extentions/fcm_type.dart';
import 'package:flutter_metalk/model/chatting_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';

class ChattingApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('chatting');

  static Future<List<ChattingVo>> getChattingList({
    required String userId,
    required String targetUserId,
  }) async {
    QuerySnapshot querySnapshot = await _ref
        .where('senderId', isEqualTo: userId)
        .where('receiverId', isEqualTo: targetUserId)
        .get();
    List<ChattingVo> senderList = List<ChattingVo>.from(querySnapshot.docs.map((e) => ChattingVo.fromQueryDocumentSnapshot(e)));

    querySnapshot = await _ref
        .where('receiverId', isEqualTo: userId)
        .where('senderId', isEqualTo: targetUserId)
        .get();
    List<ChattingVo> receiverList = List<ChattingVo>.from(querySnapshot.docs.map((e) => ChattingVo.fromQueryDocumentSnapshot(e)));

    List<ChattingVo> allList = [];
    allList.addAll(senderList);
    allList.addAll(receiverList);
    allList.sort((a, b) => a.createDt.isBefore(b.createDt) ? -1 : 1);
    return allList;
  }

  static Stream<QuerySnapshot> getSenderStream({
    required String userId,
  }) => _ref.where('senderId', isEqualTo: userId).snapshots();

  static Stream<QuerySnapshot> getReceiverStream({
    required String userId,
  }) => _ref.where('receiverId', isEqualTo: userId).snapshots();

  static Future<ChattingVo> sendChatting({
    required ChattingVo chattingVo,
    required UserVo targetUserVo,
  }) async {
    DocumentReference res = await _ref.add(chattingVo.toMap());
    ChattingVo sentChattingVo = ChattingVo.fromQueryDocumentSnapshot(await res.get());
    String? fbToken = targetUserVo.fbToken;
    if (fbToken != null) {
      FirebaseUtils.sendFbMessage(
        fbToken: fbToken,
        title: FcmTypeExt.message.name,
        data: {'msg': jsonEncode(sentChattingVo)},
      );
    }
    return ChattingVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<void> updateAllRead({
    required String userId,
    required String otherUserId,
  }) async {
    QuerySnapshot querySnapshot = await _ref
        .where('senderId', isEqualTo: otherUserId)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    List<ChattingVo> receivedUnReadList = List<ChattingVo>.from(querySnapshot.docs.map((e) => ChattingVo.fromQueryDocumentSnapshot(e)));
    if (receivedUnReadList.isNotEmpty) {
      for (ChattingVo chattingVo in receivedUnReadList) {
        await _ref.doc(chattingVo.id).update({
          'isRead': true,
        });
      }

      UserVo? userVo = await UserApi.getUserById(otherUserId);
      if (userVo != null) {
        String? fbToken = userVo.fbToken;
        if (fbToken != null) {
          FirebaseUtils.sendFbMessage(
            fbToken: fbToken,
            title: FcmTypeExt.read.name,
            data: {'userId': userId},
          );
        }
      }
    }
  }
}