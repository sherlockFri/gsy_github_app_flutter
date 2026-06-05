import 'package:gsy_github_app_flutter/common/logger.dart';
import 'package:gsy_github_app_flutter/model/user.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:redux/redux.dart';

/// 用户相关Redux
final UserReducer = combineReducers<User?>([
  TypedReducer<User?, UpdateUserAction>(_updateLoaded),
]);

User? _updateLoaded(User? user, action) {
  user = action.userInfo;
  return user;
}

class UpdateUserAction {
  final User? userInfo;

  UpdateUserAction(this.userInfo);
}

class FetchUserAction {}

class UserInfoMiddleware implements MiddlewareClass<GSYState> {
  @override
  void call(Store<GSYState> store, dynamic action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      printLog("*********** UserInfoMiddleware *********** ");
    }
    next(action);
  }
}
