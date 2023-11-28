import 'dart:ui';

import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/model/bank_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectBankModal {
  static void showModal(BuildContext context, {
    required ValueChanged<BankItem> onPressed,
  }) {
    List<BankItem> bankItems = [
      BankItem(icon: 'assets/image/bank/bank-1.png', name:'농협'),
      BankItem(icon: 'assets/image/bank/bank-2.png', name:'카카오뱅크'),
      BankItem(icon: 'assets/image/bank/bank-3.png', name:'국민은행'),
      BankItem(icon: 'assets/image/bank/bank-4.png', name:'신한-제주은행'),
      BankItem(icon: 'assets/image/bank/bank-5.png', name:'토스뱅크'),
      BankItem(icon: 'assets/image/bank/bank-6.png', name:'우리은행'),
      BankItem(icon: 'assets/image/bank/bank-7.png', name:'기업'),
      BankItem(icon: 'assets/image/bank/bank-8.png', name:'하나'),
      BankItem(icon: 'assets/image/bank/bank-9.png', name:'새마을금고'),
      BankItem(icon: 'assets/image/bank/bank-10.png', name:'부산은행'),
      BankItem(icon: 'assets/image/bank/bank-11.png', name:'대구은행'),
      BankItem(icon: 'assets/image/bank/bank-12.png', name:'케이뱅크'),
      BankItem(icon: 'assets/image/bank/bank-13.png', name:'신협'),
      BankItem(icon: 'assets/image/bank/bank-14.png', name:'우체국'),
      BankItem(icon: 'assets/image/bank/bank-15.png', name:'SC제일'),
      BankItem(icon: 'assets/image/bank/bank-16.png', name:'전북-광주은행'),
      BankItem(icon: 'assets/image/bank/bank-17.png', name:'수협'),
      BankItem(icon: 'assets/image/bank/bank-18.png', name:'저축은행'),
      BankItem(icon: 'assets/image/bank/bank-19.png', name:'시티은행'),
      BankItem(icon: 'assets/image/bank/bank-20.png', name:'KDB-산업은행'),
      BankItem(icon: 'assets/image/bank/bank-21.png', name:'산림조합중앙회'),
      BankItem(icon: 'assets/image/bank/bank-22.png', name:'SBI저축'),
      BankItem(icon: 'assets/image/bank/bank-23.png', name:'중국공산은행'),
      BankItem(icon: 'assets/image/bank/bank-24.png', name:'HSBC'),
      BankItem(icon: 'assets/image/bank/bank-25.png', name:'도이치은행'),
      BankItem(icon: 'assets/image/bank/bank-26.png', name:'jp모간체이스'),
      BankItem(icon: 'assets/image/bank/bank-27.png', name:'BNP파리바은행'),
      BankItem(icon: 'assets/image/bank/bank-28.png', name:'중국건설은행'),
      BankItem(icon: 'assets/image/bank/bank-29.png', name:'뱅크오브아메리카'),
    ];

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: ScreenUtil().setHeight(
              576,
            ),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '은행을 선택해주세요',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(16,),),
                        AutoHeightGridView(
                          shrinkWrap: true,
                          itemCount: bankItems.length,
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          padding: EdgeInsets.zero,
                          builder: (BuildContext context, int index) {
                            BankItem bankItem = bankItems[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                onPressed(bankItem);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14,),
                                  color: const Color.fromARGB(255, 236, 232, 232),
                                ),
                                height: ScreenUtil().setHeight(80,),
                                width: ScreenUtil().setWidth(104,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ImagePadding(bankItem.icon, width: 30, height: 30,),
                                    SizedBox(height: ScreenUtil().setHeight(3,),),
                                    Text(
                                      bankItem.name,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(13,),
                                        color: const Color.fromARGB(255, 64, 64, 64,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}