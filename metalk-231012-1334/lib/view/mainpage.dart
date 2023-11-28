import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/barpageonepage/filterpage.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(
          255,
          230,
          250,
          249,
        ),
        elevation: 0.0,
        title: Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(
              10,
            ),
          ),
          child: Column(
            children: [
              TabBar(
                indicator: const BoxDecoration(),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(
                    5,
                  ),
                ),
                isScrollable: true,
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
                          fontWeight: FontWeight.bold),
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
            ],
          ),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(
                255,
                230,
                250,
                249,
              ),
              Colors.white,
            ],
          ),
        ),
        child: Consumer<HomeDataProvider>(
          builder: (BuildContext context, HomeDataProvider value, Widget? child) {
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
    );
  }

  Widget _widgetItemList(List<UserVo> userVoList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          UserVo userVo = userVoList[index];

          return UserItem(
            userVo: userVo,
          );
        },
        itemCount: userVoList.length,
        //높이조절
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 12,
          );
        },
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
