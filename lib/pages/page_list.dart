import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/model_response.dart';
import '../style/color.dart';

class PageList extends StatefulWidget {
  final List<GeneralList> datas;
  final String title;

  const PageList({Key? key, required this.datas, required this.title}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _PageListState createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: ColorsTheme.primary1,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: widget.datas.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.datas[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                    child: card(item),
                  );
                })),
      ),
    );
  }

  Widget card(GeneralList item) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 16, color: ColorsTheme.primary1)),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 14, color: ColorsTheme.text1),
                  ),
                  const Divider()
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: ColorsTheme.grey)
          ],
        ));
  }
}
