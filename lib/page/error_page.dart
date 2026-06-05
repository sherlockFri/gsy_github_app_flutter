import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  const ErrorPage(this.errorMessage, this.details, {super.key});

  @override
  ErrorPageState createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQueryData.fromView(View.of(context)).size.width;
    return Container(
      color: GSYColors.primaryValue,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            gradient:
                RadialGradient(tileMode: TileMode.mirror, radius: 0.1, colors: [
              Colors.white.withAlpha(10),
              GSYColors.primaryValue.withAlpha(100),
            ]),
            borderRadius: BorderRadius.all(Radius.circular(width / 2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Image(
                  image: AssetImage(GSYICons.DEFAULT_USER_ICON),
                  width: 90.0,
                  height: 90.0),
              const SizedBox(height: 11),
              const Material(
                color: GSYColors.primaryValue,
                child: Text(
                  "Error Occur",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(100)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
