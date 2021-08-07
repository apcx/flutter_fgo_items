import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EssencePage extends StatelessWidget {
  static const TITLE = '概念礼装强化';
  static const _MAX = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 80, 100];
  static const _EXP = [
    0,
    100,
    400,
    1000,
    2000,
    3500,
    5600,
    8400,
    12000,
    16500,
    22000,
    28600,
    36400,
    45500,
    56000,
    68000,
    81600,
    96900,
    114000,
    133000,
    154000,
    177100,
    202400,
    230000,
    260000,
    292500,
    327600,
    365400,
    406000,
    449500,
    496000,
    545600,
    598400,
    654500,
    714000,
    777000,
    843600,
    913900,
    988000,
    1066000,
    1148000,
    1234100,
    1324400,
    1419000,
    1518000,
    1621500,
    1729600,
    1842400,
    1960000,
    2082500,
    2210000,
    2342600,
    2480400,
    2623500,
    2772000,
    2926000,
    3085600,
    3250900,
    3422000,
    3599000,
    3782000,
    3971100,
    4166400,
    4368000,
    4576000,
    4790500,
    5011600,
    5239400,
    5474000,
    5715500,
    5964000,
    6219600,
    6482400,
    6752500,
    7030000,
    7315000,
    7607600,
    7907900,
    8216000,
    8532000,
    8856000,
    9188100,
    9528400,
    9877000,
    10234000,
    10599500,
    10973600,
    11356400,
    11748000,
    12148500,
    12558000,
    12976600,
    13404400,
    13841500,
    14288000,
    14744000,
    15209600,
    15684900,
    16170000,
    16665000
  ];

  static final _level = 6.obs;
  static final _maxLevel = 50.obs;
  static final _next = 1600.obs;

  static int _levelExp(level) => _EXP[level] - _EXP[level - 1];

  static _maxExp(int level, int maxLevel, int next) => _EXP[maxLevel - 1] - _EXP[level] + next;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(TITLE)),
        body: Obx(() {
          final levelExp = _levelExp(_level.value);
          final divisions = (levelExp + 900) ~/ 1000;
          final maxExp = _maxExp(_level.value, _maxLevel.value, _next.value);
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 30),
            Row(children: [
              const SizedBox(width: 30),
              Text('Lv. ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(' $_level / ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('$_maxLevel')
            ]),
            RangeSlider(
                min: 1,
                max: 100,
                divisions: 99,
                values: RangeValues(_level.toDouble(), _maxLevel.toDouble()),
                onChanged: (values) {
                  final end = values.end.round();
                  try {
                    _maxLevel.value = _MAX.firstWhere((max) => max >= end);
                  } on StateError {
                    _maxLevel.value = 10;
                  }
                  _level.value = min(values.start.round(), _maxLevel.value - 1);
                  _next.value = min(_next.value, _levelExp(_level.value));
                }),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.only(left: 30), child: Text('升级剩余  $_next')),
            Slider(
                min: 0,
                max: divisions * 1000,
                divisions: divisions,
                activeColor: Colors.amber,
                inactiveColor: Colors.grey,
                value: (levelExp - _next.value).toDouble(),
                onChanged: (value) => _next.value = max(100, levelExp - value.round())),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () => _next.value = min(_next.value + 1000, levelExp)),
              IconButton(icon: Icon(Icons.arrow_forward), onPressed: () => _next.value = max(100, _next.value - 1000))
            ]),
            const SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    SizedBox(width: 140, child: Text('到$_maxLevel级所需经验：')),
                    Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Text('$maxExp', style: const TextStyle(fontSize: 20)))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    SizedBox(width: 140, child: Text('大成功所需经验：')),
                    Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Text('${(maxExp + 1) ~/ 2}', style: const TextStyle(fontSize: 20)))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    SizedBox(width: 140, child: Text('极大成功所需经验：')),
                    Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Text('${(maxExp + 2) ~/ 3}', style: const TextStyle(fontSize: 20)))
                  ]),
                ])),
          ]);
        }));
  }
}
