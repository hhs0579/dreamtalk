import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/chatting_api.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/components/chat_room_list_item.dart';
import 'package:flutter_metalk/model/chatting_room_vo.dart';
import 'package:flutter_metalk/model/chatting_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          '메세지',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: ScreenUtil().setSp(
              18,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(
            12,
          ),
        ),
        child: FutureBuilder(
          future: UserApi.getUserIfNotToLogin(),
          builder: (BuildContext context, AsyncSnapshot<UserVo?> snapshot) {
            if (snapshot.hasData == false) return const SizedBox();
            UserVo userVo = snapshot.data as UserVo;

            return StreamBuilder(
              stream: ChattingApi.getSenderStream(userId: userVo.id),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData == false || snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                List<ChattingVo> senderList = List.from(snapshot.data!.docs).map((e) => ChattingVo.fromQueryDocumentSnapshot(e)).toList();

                return StreamBuilder(
                  stream: ChattingApi.getReceiverStream(userId: userVo.id),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData == false || snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    List<ChattingVo> receiverList = List.from(snapshot.data!.docs).map((e) => ChattingVo.fromQueryDocumentSnapshot(e)).toList();

                    List<ChattingVo> chattingVoList = [];
                    chattingVoList.addAll(senderList);
                    chattingVoList.addAll(receiverList);

                    chattingVoList.sort((a, b) => a.createDt.isBefore(b.createDt) ? 1 : -1);

                    List<ChattingRoomVo> roomList = [];
                    for (ChattingVo chattingVo in chattingVoList) {
                      bool isMySender = chattingVo.senderId == userVo.id;
                      String otherUserId = isMySender ? chattingVo.receiverId : chattingVo.senderId;
                      bool isOtherUnRead = isMySender == false && chattingVo.isRead == false;

                      ChattingRoomVo? existRoom = roomList.firstWhereOrNull((e) => e.otherUserId == otherUserId);
                      if (existRoom != null) {
                        if (isOtherUnRead == true) {
                          existRoom.otherUnReadCnt += 1;
                        }
                      } else {
                        roomList.add(ChattingRoomVo(
                          otherUserId: otherUserId,
                          lastMessage: chattingVo.message,
                          lastCreateDt: chattingVo.createDt,
                          otherUnReadCnt: isOtherUnRead ? 1 : 0,
                        ));
                      }
                    }

                    return ListView.separated(
                      itemCount: roomList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ChattingRoomVo roomVo = roomList[index];

                        return ChatRoomListItem(
                          roomVo: roomVo,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: ScreenUtil().setHeight(
                            14,
                          ),
                        );
                      },
                    );
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }
}