import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/widget/mole_widget.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart' as rive;

/// 欢迎页
class WelcomePage extends ConsumerStatefulWidget {
  static const String sName = "/";

  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  bool hadInit = false;

  String text = "";
  double fontSize = 76;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    Store<GSYState> store = StoreProvider.of(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        text = "Welcome";
        fontSize = 60;
      });
    });
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        text = "App";
        fontSize = 60;
      });
    });
    Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
      // Check if user is logged in, navigate accordingly
      if (store.state.login == true) {
        NavigatorUtils.goHome(context);
      } else {
        NavigatorUtils.goLogin(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        double size = 200;
        return Material(
          child: Container(
            color: GSYColors.white,
            child: Stack(
              children: <Widget>[
                const Center(
                  child: Image(image: AssetImage('static/images/welcome.png')),
                ),
                Align(
                  alignment: const Alignment(0.0, 0.3),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      fontFamily: 'Akronim',
                      color: GSYColors.primaryDarkValue,
                      fontSize: fontSize,
                    ),
                    child: Text(text),
                  ),
                ),
                const Align(
                  alignment: Alignment(0.0, 0.8),
                  child: Mole(),
                ),
                Align(
                  alignment: const Alignment(0.0, .9),
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: rive.RiveAnimation.asset(
                      'static/file/launch.riv',
                      animations: const ["lookUp"],
                      onInit: (arb) {
                        var controller =
                            rive.StateMachineController.fromArtboard(
                                arb, "birb");
                        var smi = controller?.findInput<bool>("dance");
                        arb.addController(controller!);
                        smi?.value == true;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
