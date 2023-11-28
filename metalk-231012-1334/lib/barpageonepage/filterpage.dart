import 'package:flutter/material.dart';
import 'package:flutter_metalk/components/container_widget.dart';
import 'package:flutter_metalk/model/age_range_vo.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/filter_args.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FilterPage extends StatefulWidget {
  final FilterArgs filterArgs;

  const FilterPage({super.key,
    required this.filterArgs,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late FilterArgs filterArgs;

  @override
  void initState() {
    super.initState();
    filterArgs = widget.filterArgs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          '필터',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: ScreenUtil().setSp(
                18,
              )),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          // 로딩바
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(
                20,
              ),
              top: ScreenUtil().setHeight(
                16,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나이별',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (AgeRangeVo item in filterArgs.ageRangeVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Text(
                  '언어',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (LanguageVo item in filterArgs.languageVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        image: item.iconUrl,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    24,
                  ),
                ),
                Text(
                  '관심사',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (InterestVo item in filterArgs.interestVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        image: item.iconUrl,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    24,
                  ),
                ),
                Text(
                  '직업',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (JobVo item in filterArgs.jobVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    24,
                  ),
                ),
                Text(
                  '취미',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (HobbyVo item in filterArgs.hobbyVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    24,
                  ),
                ),
                Text(
                  '성격',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    10,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (CharacterVo item in filterArgs.characterVoList)...[
                      ContainerWidget(
                        onTap: () => setState(() => item.isChecked = !item.isChecked),
                        isChecked: item.isChecked,
                        title: item.title,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    56,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushReplacement<void, void>(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => const PhoneAuthTwo(),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(
                      335,
                    ),
                    height: ScreenUtil().setHeight(
                      56,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        21,
                        213,
                        213,
                      ),
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, filterArgs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '필터 적용하기',
                              style: TextStyle(
                                color: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                6,
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(
                                20,
                              ),
                              height: ScreenUtil().setHeight(
                                20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  '${filterArgs.getCheckedFilterCount()}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      21,
                                      213,
                                      213,
                                    ),
                                    fontSize: ScreenUtil().setSp(
                                      12,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}