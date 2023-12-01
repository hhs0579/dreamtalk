import 'package:flutter/material.dart';
import 'package:flutter_metalk/chattingpage/view/detailprofile.dart';
import 'package:flutter_metalk/components/custom_button.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/profile/manprofile/diamondpage.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';
import 'package:hexcolor/hexcolor.dart';

class UserItem extends StatelessWidget {
  final UserVo userVo;
  final bool isChatPage;
  final bool isDiamondGiftPage;

  const UserItem({
    Key? key,
    required this.userVo,
    this.isChatPage = false,
    this.isDiamondGiftPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DetailProfilePage(
              userId: userVo.id,
              isShowChat: isChatPage == false,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImagePadding(
                      userVo.profileImgUrl,
                      isNetwork: true,
                      width: width * 0.4,
                      height: height * 0.3,
                      fit: BoxFit.cover,
                      defaultColor: Colors.grey,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: userVo.isOnline
                            ? HexColor('#4CE417')
                            : HexColor('#D4D4D4'),
                      ),
                    ),  
                  ),
                  Positioned(
                    top: 8,
                    right: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ImagePadding(
                          userVo.levelExt.icon,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ImagePadding(
                          userVo.userGender.icon,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextPadding(
                              '${userVo.userName}',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                              height: 1,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextPadding(
                              '${userVo.age}세',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                              height: 1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const ImagePadding(
                              'map-icon.png',
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            TextPadding(
                              '${userVo.location}',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const ImagePadding(
                              'globe-light.png',
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            TextPadding(
                              '${userVo.firstLanguage(context)}',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Positioned(
                    bottom: 00,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff3C3939),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      width: width * 0.4,
                      height: 40,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImagePadding(
                            'chat-icon.png',
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '채팅하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
