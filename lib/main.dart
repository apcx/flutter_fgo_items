import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item_page.dart';

main() => runApp(GetMaterialApp(
    title: 'FGO素材', theme: ThemeData(platform: TargetPlatform.iOS, primarySwatch: Colors.blueGrey), home: ItemPage()));
