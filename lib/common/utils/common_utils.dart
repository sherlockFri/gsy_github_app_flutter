import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/common/local/local_storage.dart';
import 'package:gsy_github_app_flutter/common/localization/extension.dart';
import 'package:gsy_github_app_flutter/common/toast.dart';
import 'package:gsy_github_app_flutter/provider/app_state_provider.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_flex_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 通用逻辑
class CommonUtils {
  static const double MILLIS_LIMIT = 1000.0;
  static const double SECONDS_LIMIT = 60 * MILLIS_LIMIT;
  static const double MINUTES_LIMIT = 60 * SECONDS_LIMIT;
  static const double HOURS_LIMIT = 24 * MINUTES_LIMIT;
  static const double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale? curLocale;

  static String getDateStr(DateTime? date) {
    if (date == null || date.toString() == "") {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  ///日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTimes =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    return switch (subTimes) {
      < MILLIS_LIMIT => (curLocale != null)
          ? (curLocale!.languageCode != "zh")
              ? "right now"
              : "刚刚"
          : "刚刚",
      < SECONDS_LIMIT => (subTimes / MILLIS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " seconds ago"
                  : " 秒前"
              : " 秒前"),
      < MINUTES_LIMIT => (subTimes / SECONDS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " min ago"
                  : " 分钟前"
              : " 分钟前"),
      < HOURS_LIMIT => (subTimes / MINUTES_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " hours ago"
                  : " 小时前"
              : " 小时前"),
      < DAYS_LIMIT => (subTimes / HOURS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " days ago"
                  : " 天前"
              : " 天前"),
      _ => getDateStr(date)
    };
  }

  static getLocalPath() async {
    Directory? appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    String appDocPath = "${appDir!.path}/gsyapp";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static getApplicationDocumentsPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getApplicationSupportDirectory();
    }
    String appDocPath = "${appDir.path}/gsyapp";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath.path;
  }

  static String? removeTextTag(String? description) {
    if (description != null) {
      String reg = "<g-emoji.*?>.+?</g-emoji>";
      RegExp tag = RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m
            .group(0)!
            .replaceAll(RegExp("<g-emoji.*?>"), "")
            .replaceAll(RegExp("</g-emoji>"), "");
        description = description!.replaceAll(RegExp(m.group(0)!), match);
      }
    }
    return description;
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }

  static ThemeData getThemeData(Color color) {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: color as MaterialColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        primary: color,
        brightness: Brightness.light,
        surfaceTint: Colors.transparent,
      ),
      iconTheme: const IconThemeData(
        size: 24.0,
        fill: 0.0,
        weight: 400.0,
        grade: 0.0,
        opticalSize: 48.0,
        color: Colors.white,
        opacity: 0.8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: const CircleBorder()),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.white, size: 24.0),
        backgroundColor: color,
        titleTextStyle: Typography.dense2021.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  static showLanguageDialog(WidgetRef ref) {
    List<String> list = [
      ref.context.l10n.home_language_default,
      ref.context.l10n.home_language_zh,
      ref.context.l10n.home_language_en,
      ref.context.l10n.home_language_ko,
      ref.context.l10n.home_language_ja,
    ];
    CommonUtils.showCommitOptionDialog(ref.context, list, (index) {
      ref.read(appLocalStateProvider.notifier).changeLocale(index.toString());
      LocalStorage.save(Config.LOCALE, index.toString());
    }, height: 300.0);
  }

  ///获取设备信息
  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return "";
    }
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.model;
  }

  static List<Color> getThemeListColor() {
    return [
      GSYColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  static copy(String? data, BuildContext context) {
    if (data != null) {
      Clipboard.setData(ClipboardData(text: data));
      showToast(context.l10n.option_share_copy_success);
    }
  }

  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
              color: Colors.transparent,
              child: PopScope(
                canPop: false,
                child: Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SpinKitCubeGrid(color: GSYColors.white),
                        Container(height: 10.0),
                        Text(context.l10n.loading_text,
                            style: GSYConstant.normalTextWhite),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  ///列表item dialog
  static Future<void> showCommitOptionDialog(
    BuildContext context,
    List<String?>? commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color>? colorList,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: GSYColors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: ListView.builder(
                  itemCount: commitMaps?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GSYFlexButton(
                      maxLines: 1,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null
                          ? colorList[index]
                          : Theme.of(context).primaryColor,
                      text: commitMaps![index],
                      textColor: GSYColors.white,
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }
}
