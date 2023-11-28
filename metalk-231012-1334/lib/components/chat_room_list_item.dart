import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/chattingpage/view/detailchatting.dart';
import 'package:flutter_metalk/chattingpage/view/detailprofile.dart';
import 'package:flutter_metalk/components/custom_button.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/model/chatting_room_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatRoomListItem extends StatelessWidget {
  final ChattingRoomVo roomVo;

  const ChatRoomListItem({Key? key,
    required this.roomVo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DatailChattingPage(
                targetUserId: roomVo.otherUserId,
              ),
            ),
          ),
          child: FutureBuilder(
            future: UserApi.getUserById(roomVo.otherUserId),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData == false) return const SizedBox();
              UserVo otherUserVo = snapshot.data;

              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailProfilePage(
                              userId: roomVo.otherUserId,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ImagePadding(
                            otherUserVo.profileImgUrl,
                            width: 64,
                            height: 64,
                            isNetwork: true,
                            fit: BoxFit.cover,
                            isCircle: true,
                            defaultColor: Colors.grey,
                          ),
                          Positioned(
                            top: ScreenUtil().setHeight(
                              40,
                            ),
                            left: ScreenUtil().setWidth(
                              50,
                            ),
                            child: Container(
                              width: ScreenUtil().setWidth(
                                14,
                              ),
                              height: ScreenUtil().setHeight(
                                14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 122, 224, 125),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(
                      16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImagePadding(
                              otherUserVo.levelExt.icon,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(
                                  2,
                                ),
                              ),
                              child: Text(
                                otherUserVo.userName ?? '',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                6,
                              ),
                            ),
                            //피그마 남여이미지
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  245,
                                  245,
                                  245,
                                ),
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                              ),
                              width: ScreenUtil().setWidth(
                                58,
                              ),
                              height: ScreenUtil().setHeight(
                                20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/globe-light.svg",
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(
                                      2,
                                    ),
                                  ),
                                  Text(
                                    otherUserVo.firstLanguage(context)!,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        12,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        82,
                                        82,
                                        82,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            4,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              roomVo.lastMessage,
                              style: TextStyle(
                                color: const Color.fromARGB(
                                  255,
                                  64,
                                  64,
                                  64,
                                ),
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        roomVo.createDtStr,
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            163,
                            163,
                            163,
                          ),
                          fontSize: ScreenUtil().setSp(
                            12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4,),
                      if (roomVo.otherUnReadCnt > 0)...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              3,
                              201,
                              195,
                            ),
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                          width: ScreenUtil().setWidth(24),
                          height: ScreenUtil().setHeight(
                            24,
                          ),
                          child: Center(
                            child: Text(
                              roomVo.otherUnReadCnt.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ]else...[
                        SizedBox(width: 24, height: 24,),
                      ],
                    ],
                  ),
                  SizedBox(width: 20,),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(
            12,
          ),
        ),
        Container(
          color: const Color.fromARGB(
            255,
            245,
            245,
            245,
          ),
          width: ScreenUtil().setWidth(
            375,
          ),
          height: ScreenUtil().setHeight(
            1,
          ),
        ),
      ],
    );
  }
}
