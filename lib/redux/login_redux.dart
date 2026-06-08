import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/common/local/local_storage.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:redux/redux.dart';

/// 登录相关Redux
final LoginReducer = combineReducers<bool?>([
  TypedReducer<bool?, LoginSuccessAction>(_loginResult).call,
  TypedReducer<bool?, LogoutAction>(_logoutResult).call,
]);

bool? _loginResult(bool? result, LoginSuccessAction action) {
  if (action.success == true) {
    NavigatorUtils.goHome(action.context);
  }
  return action.success;
}

bool? _logoutResult(bool? result, LogoutAction action) {
  return true;
}

class LoginSuccessAction {
  final BuildContext context;
  final bool success;

  LoginSuccessAction(this.context, this.success);
}

class LogoutAction {
  final BuildContext context;

  LogoutAction(this.context);
}

class LoginAction {
  final BuildContext context;
  final String? username;
  final String? password;

  LoginAction(this.context, this.username, this.password);
}

///中间过程处理
class LoginMiddleware implements MiddlewareClass<GSYState> {
  @override
  void call(Store<GSYState> store, dynamic action, NextDispatcher next) {
    if (action is LogoutAction) {
      LocalStorage.remove(Config.TOKEN_KEY);
      LocalStorage.remove(Config.USER_INFO);
      NavigatorUtils.goLogin(action.context);
    }
    next(action);
  }
}
