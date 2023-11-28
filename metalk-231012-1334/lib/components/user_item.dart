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

  const UserItem({Key? key,
    required this.userVo,
    this.isChatPage = false,
    this.isDiamondGiftPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isChatPage == false && isDiamondGiftPage == false ? BorderRadius.circular(20) : null,
        boxShadow: isChatPage == false && isDiamondGiftPage == false ? [
          BoxShadow(
            color: const Color(0xffD9D9D9).withOpacity(.4),
            spreadRadius: 0,
            blurRadius: 64,
            offset: const Offset(6, -2),
          ),
        ] : null,
      ),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DetailProfilePage(
              userId: userVo.id,
              isShowChat: isChatPage == false,
            ),
          ),
        ),
        style: CustomStyles.textButtonZeroSize(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  ImagePadding(
                    userVo.profileImgUrl,
                    isNetwork: true,
                    width: isChatPage == false ? 64 : 48,
                    height: isChatPage == false ? 65 : 48,
                    isCircle: true,
                    fit: BoxFit.cover,
                    defaultColor: Colors.grey,
                  ),
                  Positioned(
                    bottom: isChatPage == false ? 4 : 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: userVo.isOnline ? HexColor('#4CE417') : HexColor('#D4D4D4'),
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: isChatPage == false ? 16 : 12,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImagePadding(userVo.levelExt.icon, width: 24, height: 24,),
                      SizedBox(width: isChatPage == false ? 4 : 2,),
                      TextPadding('${userVo.userName}, ${userVo.age}세', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black, height: 1,),
                      SizedBox(width: isChatPage == false ? 8 : 6,),
                      ImagePadding(userVo.userGender.icon, width: 20, height: 20),
                    ],
                  ),
                  const SizedBox(height: 6,),
                  Row(
                    children: [
                      const ImagePadding('map-icon.png', width: 12, height: 12,),
                      const SizedBox(width: 2,),
                      TextPadding('${userVo.location}', fontWeight: FontWeight.w600, fontSize: 12, color: HexColor('#525252'),),
                      const SizedBox(width: 6,),
                      const ImagePadding('globe-light.png', width: 12, height: 12,),
                      const SizedBox(width: 2,),
                      TextPadding('${userVo.firstLanguage(context)}', fontWeight: FontWeight.w600, fontSize: 12, color: HexColor('#525252'),),
                    ],
                  ),
                ],
              )),
              if (isDiamondGiftPage == true)...[
                const SizedBox(width: 5,),
                CustomButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DiamondPage())),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: HexColor('#E6FAF9'),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: ImagePadding('send-diamond.png'),
                    ),
                  ),
                ),
              ] else if (isChatPage == false)...[
                const SizedBox(width: 5,),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: HexColor('#E6FAF9'),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: ImagePadding('chat-icon.png', width: 16, height: 16,),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
