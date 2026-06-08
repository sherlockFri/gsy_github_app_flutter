import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/localization/extension.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/page/dynamic_page.dart';
import 'package:gsy_github_app_flutter/page/my_page.dart';
import 'package:gsy_github_app_flutter/page/trend_page.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabbar_widget.dart';
import 'package:gsy_github_app_flutter/widget/gsy_title_bar.dart';

/// 主页
class HomePage extends StatefulWidget {
  static const String sName = "home";

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<MyPageState> myKey = GlobalKey();

  _renderTab(icon, text) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(icon, size: 16.0), Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, context.l10n.home_dynamic),
      _renderTab(GSYICons.MAIN_QS, context.l10n.home_trend),
      _renderTab(GSYICons.MAIN_MY, context.l10n.home_my),
    ];

    return GSYTabBarWidget(
      type: TabType.bottom,
      tabItems: tabs,
      tabViews: [
        const DynamicPage(),
        const TrendPage(),
        MyPage(key: myKey),
      ],
      backgroundColor: GSYColors.primarySwatch,
      indicatorColor: GSYColors.white,
      title: GSYTitleBar(context.l10n.app_name),
    );
  }
}
