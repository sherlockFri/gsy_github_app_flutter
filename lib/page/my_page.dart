import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/redux/user_redux.dart';
import 'package:redux/redux.dart';

/// 主页我的tab页
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  Store<GSYState>? _getStore() {
    return StoreProvider.of(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        final userInfo = store.state.userInfo;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (userInfo != null) ...[
                  const Icon(GSYICons.MAIN_MY, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    userInfo.name ?? userInfo.username ?? 'User',
                    style: GSYConstant.largeText,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userInfo.email ?? '',
                    style: GSYConstant.smallSubText,
                  ),
                  const SizedBox(height: 40),
                ],
                if (userInfo == null)
                  const Text(
                    'Not logged in',
                    style: GSYConstant.normalText,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
