import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gsy_github_app_flutter/common/event/http_error_event.dart';
import 'package:gsy_github_app_flutter/common/event/index.dart';
import 'package:gsy_github_app_flutter/common/localization/extension.dart';
import 'package:gsy_github_app_flutter/common/localization/l10n/app_localizations.dart';
import 'package:gsy_github_app_flutter/common/net/code.dart';
import 'package:gsy_github_app_flutter/common/toast.dart';
import 'package:gsy_github_app_flutter/model/user.dart';
import 'package:gsy_github_app_flutter/page/home/home_page.dart';
import 'package:gsy_github_app_flutter/page/login/login_page.dart';
import 'package:gsy_github_app_flutter/page/photoview_page.dart';
import 'package:gsy_github_app_flutter/page/welcome_page.dart';
import 'package:gsy_github_app_flutter/provider/app_state_provider.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:redux/redux.dart';

import 'common/utils/navigator_utils.dart';

class FlutterReduxApp extends StatefulWidget {
  const FlutterReduxApp({super.key});

  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp>
    with HttpErrorListener {
  final store = Store<GSYState>(
    appReducer,
    middleware: middleware,
    initialState: GSYState(
      userInfo: User.empty(),
      login: false,
    ),
  );

  NavigatorObserver navigatorObserver = NavigatorObserver();

  Locale _checkSupportedLocale(Locale locale) {
    const supportedLocales = AppLocalizations.supportedLocales;
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return locale;
      }
    }
    return const Locale('en', 'US');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      navigatorObserver.navigator!.context;
      navigatorObserver.navigator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: globalContainer,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final (greyApp, appLocale, themeData) = ref.watch(appStateProvider);
          final effectiveLocale = _checkSupportedLocale(appLocale);

          return StoreProvider(
            store: store,
            child: StoreBuilder<GSYState>(builder: (context, store) {
              Widget app = MaterialApp(
                  navigatorKey: navKey,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: [effectiveLocale],
                  locale: effectiveLocale,
                  theme: themeData,
                  navigatorObservers: [navigatorObserver],
                  routes: {
                    WelcomePage.sName: (context) {
                      return const WelcomePage();
                    },
                    HomePage.sName: (context) {
                      return NavigatorUtils.pageContainer(
                          const HomePage(), context);
                    },
                    LoginPage.sName: (context) {
                      return NavigatorUtils.pageContainer(
                          const LoginPage(), context);
                    },
                    PhotoViewPage.sName: (context) {
                      return const PhotoViewPage();
                    },
                  });

              if (greyApp) {
                app = ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Colors.grey, BlendMode.saturation),
                    child: app);
              }

              return app;
            }),
          );
        },
      ),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription? stream;
  GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int? code, message) {
    var context = navKey.currentContext!;
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast(context.l10n.network_error);
        break;
      case 401:
        showToast(context.l10n.network_error_401);
        break;
      case 403:
        showToast(context.l10n.network_error_403);
        break;
      case 404:
        showToast(context.l10n.network_error_404);
        break;
      case 422:
        showToast(context.l10n.network_error_422);
        break;
      case Code.NETWORK_TIMEOUT:
        showToast(context.l10n.network_error_timeout);
        break;
      default:
        showToast("${context.l10n.network_error_unknown} $message");
        break;
    }
  }
}
