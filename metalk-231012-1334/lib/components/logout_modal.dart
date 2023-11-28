import 'package:flutter/material.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';

class LogoutModal {
  static void showModal(BuildContext context, VoidCallback onPressed) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '로그아웃 하기\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: '로그아웃 하시겠습니까?'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1.5,
                  color: Colors.grey[100],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextButton(
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                            style: CustomStyles.textButtonZeroSize(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey[500],
                            ),
                            child: const Center(
                              child: Text(
                                '닫기',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.grey[100],
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () => {
                              Navigator.pop(context),
                              onPressed(),
                            },
                            style: CustomStyles.textButtonZeroSize(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey[500],
                            ),
                            child: const Center(
                              child: Text(
                                '로그아웃',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            scrollable: true,
          );
        }
    );
  }
}