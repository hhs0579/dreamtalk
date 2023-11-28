import 'package:flutter/material.dart';
import 'package:flutter_metalk/components/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionPopup {
  static void showPopup(BuildContext context) {
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
                          text: '위치 권한이 꺼져있습니다.\n[권한] 설정에서 위치 권한을\n허용해야 합니다.',
                        ),
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
                          child: CustomButton(
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.grey[500],
                            child: const Center(
                              child: Text(
                                '취소',
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
                          child: CustomButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Geolocator.openLocationSettings();
                            },
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.grey[500],
                            child: const Center(
                              child: Text(
                                '설정으로 가기',
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