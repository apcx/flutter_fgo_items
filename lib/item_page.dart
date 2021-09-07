import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item.dart';

final _selected = Rx<Item?>(null);

class ItemPage extends StatelessWidget {
  static const TITLE = '多素材综合效率表';
  static final _future = loadQuests();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(TITLE), actions: [
        TextButton(
            child: Text('素材过滤', style: TextStyle(color: Colors.white)), onPressed: () => Get.to(() => ItemFilterPage()))
      ]),
      body: FutureBuilder(
          future: _future,
          builder: (_, snapshot) => snapshot.connectionState != ConnectionState.done
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Checkbox(value: Quest.classHalfAp.value, onChanged: (v) => Quest.classHalfAp.value = v!),
                          Text('修炼场 AP 消耗 1 / 2')
                        ]),
                        Wrap(children: Item.bronze.map((item) => ItemButton(item)).toList()),
                        Wrap(children: Item.silver.map((item) => ItemButton(item)).toList()),
                        Wrap(children: Item.gold.map((item) => ItemButton(item)).toList()),
                        Wrap(children: Item.gem.map((item) => ItemButton(item)).toList()),
                        if (_selected.value != null) ..._selected.value!.bestQuests.map((quest) => QuestWidget(quest))
                      ])))));
}

class ItemButton extends StatelessWidget {
  final Item item;

  ItemButton(this.item);

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.all(1),
      width: 32,
      height: 32,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              side: BorderSide(color: _selected.value == item ? Colors.redAccent : Colors.grey[300]!)),
          child: item.icon,
          onPressed: () => _selected.value = item));
}

class QuestWidget extends StatelessWidget {
  final Quest quest;

  QuestWidget(this.quest);

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Row(children: [
        SizedBox(
            width: 98,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(quest.area, style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
              Text(quest.name, style: const TextStyle(fontSize: 12))
            ])),
        Expanded(
            child:
                Wrap(children: quest.items.map((item) => SizedBox(width: 22, height: 22, child: item.icon)).toList())),
        SizedBox(
            width: 60,
            child: Column(children: [
              Text('${quest.itemAp.toStringAsFixed(2)}'),
              if (quest == _selected.value?.quests[0])
                Text('单素材最高', style: const TextStyle(fontSize: 12, color: Colors.deepPurpleAccent))
            ]))
      ]));
}

class ItemFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('素材过滤')),
        body: Column(children: [
          Wrap(children: Item.bronze.map((item) => ItemFilterButton(item)).toList()),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('铜素材'),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全需要'), onPressed: () => Item.bronze.forEach((item) => item.excluded.value = false)),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全不需要'), onPressed: () => Item.bronze.forEach((item) => item.excluded.value = true)),
            const SizedBox(width: 8)
          ]),
          Wrap(children: Item.silver.map((item) => ItemFilterButton(item)).toList()),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('银素材'),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全需要'), onPressed: () => Item.silver.forEach((item) => item.excluded.value = false)),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全不需要'), onPressed: () => Item.silver.forEach((item) => item.excluded.value = true)),
            const SizedBox(width: 8)
          ]),
          Wrap(children: Item.gold.map((item) => ItemFilterButton(item)).toList()),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('金素材'),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全需要'), onPressed: () => Item.gold.forEach((item) => item.excluded.value = false)),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全不需要'), onPressed: () => Item.gold.forEach((item) => item.excluded.value = true)),
            const SizedBox(width: 8)
          ]),
          Wrap(children: Item.gem.map((item) => ItemFilterButton(item)).toList()),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('职介秘石'),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全需要'), onPressed: () => Item.gem.forEach((item) => item.excluded.value = false)),
            const SizedBox(width: 8),
            ElevatedButton(
                child: Text('全不需要'), onPressed: () => Item.gem.forEach((item) => item.excluded.value = true)),
            const SizedBox(width: 8)
          ])
        ]));
  }
}

class ItemFilterButton extends StatelessWidget {
  final Item item;

  ItemFilterButton(this.item);

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.all(1),
      width: 48,
      height: 48,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
          onPressed: () => item.excluded.toggle(),
          child: Obx(() => Stack(children: [
                Center(
                    child: item.excluded.value
                        ? ColorFiltered(
                            colorFilter: ColorFilter.mode(Colors.grey[100]!, BlendMode.saturation), child: item.icon)
                        : item.icon),
                if (item.excluded.value) Center(child: Icon(Icons.clear, color: Colors.redAccent))
              ]))));
}
