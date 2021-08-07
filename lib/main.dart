import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'essence.dart';
import 'item_page.dart';

main() {
  final title = 'FGO素材';
  runApp(GetMaterialApp(
      title: title,
      theme: ThemeData(platform: TargetPlatform.iOS, primarySwatch: Colors.blueGrey),
      home: HomePage(title)));
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage(this.title);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(child: Text(ItemPage.TITLE), onPressed: () => Get.to(() => ItemPage())),
        SizedBox(height: 10),
        ElevatedButton(child: Text(EssencePage.TITLE), onPressed: () => Get.to(() => EssencePage())),
      ])));
}
