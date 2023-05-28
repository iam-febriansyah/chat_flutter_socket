import 'dart:async';

import 'package:chat/style/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WidgetLoadingUser extends StatefulWidget {
  const WidgetLoadingUser({super.key});

  @override
  State<WidgetLoadingUser> createState() => _WidgetLoadingUserState();
}

class _WidgetLoadingUserState extends State<WidgetLoadingUser> {
  Timer? timer;

  var listLength = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  double len = 0.5;
  double len2 = 1;

  void reloadLength() {
    if (mounted) {
      setState(() {
        len = (listLength..shuffle()).first;
        len2 = (listLength..shuffle()).first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => reloadLength());
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorsTheme.text4.withOpacity(0.2),
      highlightColor: ColorsTheme.background1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsTheme.background2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 20,
                    width: MediaQuery.of(context).size.width * len,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsTheme.background2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 20,
                    width: MediaQuery.of(context).size.width * len2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
