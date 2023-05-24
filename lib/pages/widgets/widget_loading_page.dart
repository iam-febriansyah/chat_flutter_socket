import 'package:flutter/cupertino.dart';

class WidgetLoadingPage extends StatefulWidget {
  const WidgetLoadingPage({super.key});

  @override
  State<WidgetLoadingPage> createState() => _WidgetLoadingPageState();
}

class _WidgetLoadingPageState extends State<WidgetLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator();
  }
}
