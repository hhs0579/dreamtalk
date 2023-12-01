import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/barpageonepage/filterpage.dart';
import 'package:flutter_metalk/colors/colors.dart';
import 'package:flutter_metalk/components/user_item.dart';
import 'package:flutter_metalk/model/filter_args.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/providers/home_data_provider.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late FilterArgs _filterArgs;

  @override
  void initState() {
    super.initState();
    _filterArgs = FilterArgs.initFilter(context);
    _tabController = TabController(length: 4, vsync: this);
    _reloadDataByFilter();
  }

  void _reloadDataByFilter() {
    UserApi.getUserIfNotToLogin().then((userVo) {
      context.read<HomeDataProvider>().refreshData(
            userVo: userVo!,
            filterArgs: _filterArgs,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Image.asset(
          'assets/image/dream.png',
          scale: 2,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(
                12,
              ),
              bottom: ScreenUtil().setHeight(
                5,
              ),
            ),
            child: GestureDetector(
              onTap: () => _onPressedFilter(),
              child: SvgPicture.asset(
                "assets/image/action.svg",
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Column(
              children: [
                TabBar(
                  labelPadding:
                      const EdgeInsets.only(left: 2, right: 2, bottom: 10),
                  controller: _tabController,
                  labelColor: const Color.fromARGB(
                    255,
                    23,
                    23,
                    23,
                  ),
                  unselectedLabelColor: const Color.fromARGB(
                    255,
                    163,
                    163,
                    163,
                  ),
                  indicatorColor: ColorList.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 1,
                  tabs: [
                    Tab(
                      child: Text(
                        '신규가입',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              18,
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Hot Rank',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              18,
                            ),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffB118E1)),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '거리순',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              18,
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '접속중',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            18,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Expanded(
              child: Consumer<HomeDataProvider>(
                builder: (BuildContext context, HomeDataProvider value,
                    Widget? child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _widgetItemList(value.recentUserVoList),
                      _widgetItemList(value.hotRankUserVoList),
                      _widgetItemList(value.distanceUserVoList),
                      _widgetItemList(value.onlineUserVoList),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetItemList(List<UserVo> userVoList) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 1),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 열 수
          crossAxisSpacing: 2, // 열 간격
          mainAxisSpacing: 2, // 행 간격
          childAspectRatio: 0.7, // 각 그리드 아이템의 가로 세로 비율
        ),
        itemBuilder: (BuildContext context, int index) {
          UserVo userVo = userVoList[index];
          return UserItem(
            userVo: userVo,
          );
        },
        itemCount: userVoList.length,
      ),
    );
  }

  Future<void> _onPressedFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FilterPage(
          filterArgs: FilterArgs.clone(_filterArgs),
        ),
      ),
    );
    if (result != null && result.runtimeType == _filterArgs.runtimeType) {
      _filterArgs = result;
      _reloadDataByFilter();
    }
  }
}
