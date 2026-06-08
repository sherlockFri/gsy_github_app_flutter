import 'package:dio/dio.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/common/local/local_storage.dart';
import 'package:gsy_github_app_flutter/common/logger.dart';

/// Token拦截器
class TokenInterceptors extends InterceptorsWrapper {
  String? _token;

  @override
  onRequest(RequestOptions options, handler) async {
    _token ??= await LocalStorage.get(Config.TOKEN_KEY);
    if (_token != null) {
      options.headers["Authorization"] = _token;
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, handler) async {
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson["token"] != null) {
        _token = 'Bearer ${responseJson["token"]}';
        await LocalStorage.save(Config.TOKEN_KEY, _token);
      }
    } catch (e) {
      printLog(e);
    }
    return super.onResponse(response, handler);
  }

  ///清除授权
  clearAuthorization() {
    _token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  ///获取授权token
  getAuthorization() async {
    String? token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token != null) {
      _token = token;
      return token;
    }
    return null;
  }
}
