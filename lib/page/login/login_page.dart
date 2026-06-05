import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/common/local/local_storage.dart';
import 'package:gsy_github_app_flutter/common/localization/extension.dart';
import 'package:gsy_github_app_flutter/common/toast.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/redux/login_redux.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/animated_background.dart';
import 'package:gsy_github_app_flutter/widget/gsy_flex_button.dart';
import 'package:gsy_github_app_flutter/widget/gsy_input_widget.dart';
import 'package:gsy_github_app_flutter/widget/particle/particle_widget.dart';

/// 登录页
class LoginPage extends StatefulWidget {
  static const String sName = "login";

  const LoginPage({super.key});

  @override
  State createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with LoginBLoC {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Stack(children: <Widget>[
              const Positioned.fill(child: AnimatedBackground()),
              const Positioned.fill(child: ParticlesWidget(30)),
              Center(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      color: GSYColors.cardWhite,
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Image(
                                image: AssetImage(GSYICons.DEFAULT_USER_ICON),
                                width: 90.0,
                                height: 90.0),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            GSYInputWidget(
                              hintText: context.l10n.login_username_hint_text,
                              iconData: GSYICons.LOGIN_USER,
                              onChanged: (String value) {
                                _userName = value;
                              },
                              controller: userController,
                            ),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            GSYInputWidget(
                              hintText: context.l10n.login_password_hint_text,
                              iconData: GSYICons.LOGIN_PW,
                              obscureText: true,
                              onChanged: (String value) {
                                _password = value;
                              },
                              controller: pwController,
                            ),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            SizedBox(
                              height: 50,
                              child: GSYFlexButton(
                                text: context.l10n.login_text,
                                color: Theme.of(context).primaryColor,
                                textColor: GSYColors.textWhite,
                                fontSize: 16,
                                onPress: loginIn,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(15.0)),
                            InkWell(
                              onTap: () {
                                CommonUtils.showLanguageDialog(ref);
                              },
                              child: Text(
                                context.l10n.switch_language,
                                style: const TextStyle(
                                    color: GSYColors.subTextColor),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(15.0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          );
        }),
      ),
    );
  }
}

mixin LoginBLoC on State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  String? _userName = "";
  String? _password = "";

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    userController.removeListener(_usernameChange);
    pwController.removeListener(_passwordChange);
  }

  _usernameChange() {
    _userName = userController.text;
  }

  _passwordChange() {
    _password = pwController.text;
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = TextEditingValue(text: _userName ?? "");
    pwController.value = TextEditingValue(text: _password ?? "");
  }

  loginIn() async {
    if (_userName == null || _userName!.isEmpty) {
      showToast(context.l10n.login_username_hint_text);
      return;
    }
    if (_password == null || _password!.isEmpty) {
      showToast(context.l10n.login_password_hint_text);
      return;
    }
    // Dispatch login action via Redux for downstream implementation
    StoreProvider.of<GSYState>(context)
        .dispatch(LoginAction(context, _userName, _password));
  }
}
