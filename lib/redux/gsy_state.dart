// ignore_for_file: implicit_call_tearoffs

import 'package:gsy_github_app_flutter/model/user.dart';
import 'package:gsy_github_app_flutter/redux/login_redux.dart';
import 'package:gsy_github_app_flutter/redux/user_redux.dart';
import 'package:redux/redux.dart';

///全局Redux store 的对象，保存State数据
class GSYState {
  ///用户信息
  User? userInfo;

  ///是否登录
  bool? login;

  ///构造方法
  GSYState({this.userInfo, this.login});
}

///创建 Reducer
GSYState appReducer(GSYState state, action) {
  return GSYState(
    userInfo: UserReducer(state.userInfo, action),
    login: LoginReducer(state.login, action),
  );
}

final List<Middleware<GSYState>> middleware = [
  UserInfoMiddleware(),
  LoginMiddleware(),
];
