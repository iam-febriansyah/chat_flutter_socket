import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../style/color.dart';

class WidgetProgressSubmit extends StatelessWidget {
  const WidgetProgressSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 50,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              const SizedBox(
                  height: 30,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SpinKitChasingDots(
                      color: ColorsTheme.primary1,
                      size: 30.0,
                    ),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text(
                    "Please wait...",
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Processing data",
                      style: TextStyle(
                        color: ColorsTheme.text2,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
