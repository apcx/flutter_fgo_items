import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future loadQuests() async {
  if (Quest.free.isNotEmpty) return;
  // Quest.free.clear();
  // Item.bronze.clear();
  // Item.silver.clear();
  // Item.gold.clear();
  // Item.gem.clear();

  // load csv
  final csv = await rootBundle.loadString('assets/drop.csv');
  final rows = CsvToListConverter(allowInvalid: false).convert(csv);
  // debugPrint('rows = ${rows.length}, $csv');

  // load quests
  final bronzes = Item._BRONZE_NAMES.length;
  final silvers = Item._SILVER_NAMES.length;
  final golds = Item._GOLD_NAMES.length;
  final gems = Item._GEM_NAMES.length;
  for (int i = 3, j = 0, n = Quest._NAMES.length; i < 299; ++i) {
    final row = rows[i];
    String area = row[0];
    if (area.isEmpty || area == 'エリア') continue;
    // debugPrint('columns = ${row.length}, $row');
    final quest = Quest(row.sublist(0, 109), j < n ? Quest._NAMES[j++] : null);
    quest.bronze.removeRange(bronzes, quest.bronze.length);
    quest.silver.removeRange(silvers, quest.silver.length);
    quest.gold.removeRange(golds, quest.gold.length);
    // debugPrint('$quest');
    Quest.free.add(quest);
  }

  // init items
  for (int i = 0; i < bronzes; ++i) Item.bronze.add(Item(0, i, Item._BRONZE_NAMES[i]));
  for (int i = 0; i < silvers; ++i) Item.silver.add(Item(1, i, Item._SILVER_NAMES[i]));
  for (int i = 0; i < golds; ++i) Item.gold.add(Item(2, i, Item._GOLD_NAMES[i]));
  for (int i = 0; i < gems; ++i) Item.gem.add(Item(5, i, Item._GEM_NAMES[i]));
  for (final quest in Quest.free) {
    for (int i = 0; i < bronzes; ++i) if (quest.bronze[i] > 0) Item.bronze[i].quests.add(quest);
    for (int i = 0; i < silvers; ++i) if (quest.silver[i] > 0) Item.silver[i].quests.add(quest);
    for (int i = 0; i < golds; ++i) if (quest.gold[i] > 0) Item.gold[i].quests.add(quest);
    for (int i = 0; i < gems; ++i) if (quest.gem[i] > 0) Item.gem[i].quests.add(quest);
  }

  // sort item quests by item drop
  for (int i = 0; i < bronzes; ++i) {
    final item = Item.bronze[i];
    item.quests.sort((quest1, quest2) {
      final drop1 = quest1.bronze[i] / quest1.samples / quest1.ap;
      final drop2 = quest2.bronze[i] / quest2.samples / quest2.ap;
      return drop1 < drop2 ? 1 : (drop1 > drop2 ? -1 : 0);
    });
    final quest = item.quests[0];
    item.ap = quest.ap / (quest.bronze[i] / quest.samples);
    switch (item.name) {
      case '英雄之证':
        item.ap /= 1.15;
        break;
      case '凶骨':
        item.ap /= 1.25;
        break;
      case '龙之牙':
        item.ap /= 1.15;
        break;
      case '虚影之尘':
        item.ap /= 1.25;
        break;
      case '愚者之锁':
        item.ap /= 1.05;
        break;
      case '万死的毒针':
        item.ap /= 1.05;
        break;
      case '魔术髓液':
        item.ap /= 1.05;
        break;
      case '宵泣之铁桩':
        item.ap /= 1.05;
        break;
      case '振荡火药':
        item.ap /= 1.05;
        break;
    }
  }
  for (int i = 0; i < silvers; ++i) {
    final item = Item.silver[i];
    item.quests.sort((quest1, quest2) {
      final drop1 = quest1.silver[i] / quest1.samples / quest1.ap;
      final drop2 = quest2.silver[i] / quest2.samples / quest2.ap;
      return drop1 < drop2 ? 1 : (drop1 > drop2 ? -1 : 0);
    });
    final quest = item.quests[0];
    item.ap = quest.ap / (quest.silver[i] / quest.samples);
    switch (item.name) {
      case '世界树之种':
        item.ap /= 1.05;
        break;
      case '鬼魂提灯':
        item.ap /= 1.05;
        break;
      case '八连双晶':
        item.ap /= 1.15;
        break;
      case '蛇之宝玉':
        item.ap /= 1.05;
        break;
      case '凤凰羽毛':
        item.ap /= 1.15;
        break;
      case '无间齿轮':
        item.ap /= 1.1;
        break;
      case '禁断书页':
        item.ap /= 1.15;
        break;
      case '人工生命体幼体':
        item.ap /= 1.05;
        break;
      case '陨蹄铁':
        item.ap /= 1.05;
        break;
      case '大骑士勋章':
        item.ap /= 1.05;
        break;
      case '追忆的贝壳':
        item.ap /= 1.15;
        break;
    }
  }
  for (int i = 0; i < golds; ++i) {
    final item = Item.gold[i];
    item.quests.sort((quest1, quest2) {
      final drop1 = quest1.gold[i] / quest1.samples / quest1.ap;
      final drop2 = quest2.gold[i] / quest2.samples / quest2.ap;
      return drop1 < drop2 ? 1 : (drop1 > drop2 ? -1 : 0);
    });
    final quest = item.quests[0];
    item.ap = quest.ap / (quest.gold[i] / quest.samples);
    switch (item.name) {
      case '混沌之爪':
        item.ap /= 1.05;
        break;
      case '蛮神心脏':
        item.ap /= 1.05;
        break;
      case '龙之逆鳞':
        item.ap /= 1.05;
        break;
      case '血之泪石':
        item.ap /= 1.05;
        break;
    }
  }
  for (int i = 0; i < gems; ++i) {
    final item = Item.gem[i];
    item.quests.sort((quest1, quest2) {
      final drop1 = quest1.gem[i] / quest1.samples / quest1.ap;
      final drop2 = quest2.gem[i] / quest2.samples / quest2.ap;
      return drop1 < drop2 ? 1 : (drop1 > drop2 ? -1 : 0);
    });
    final quest = item.quests[0];
    item.ap = quest.ap / (quest.gem[i] / quest.samples);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (final item in Item.bronze) item.excluded.value = prefs.getBool(item.name) == true;
  for (final item in Item.silver) item.excluded.value = prefs.getBool(item.name) == true;
  for (final item in Item.gold) item.excluded.value = prefs.getBool(item.name) == true;
  for (final item in Item.gem) item.excluded.value = prefs.getBool(item.name) == true;
  Item.relationExclude.value = prefs.getBool("relation") == true;
  Item.relationExclude.listen((v) => (prefs).setBool("relation", v));

  if (kReleaseMode) return;
  for (final item in Item.bronze) debugPrint('$item');
  for (final item in Item.silver) debugPrint('$item');
  for (final item in Item.gold) debugPrint('$item');
  for (final item in Item.gem) debugPrint('$item');
}

// https://docs.google.com/spreadsheets/d/e/2PACX-1vQerC77YrlI1wQaJHUlDl3VBNh3zx6YDWbF8syDM3DsoG3npubnlG68VY9GlYwRAiP5RCOqQEHZoF4c/pubhtml?gid=1838972973#
// https://docs.google.com/spreadsheets/d/e/2PACX-1vQerC77YrlI1wQaJHUlDl3VBNh3zx6YDWbF8syDM3DsoG3npubnlG68VY9GlYwRAiP5RCOqQEHZoF4c/pub?output=xlsx
// sheet updated: 2024/1/28
class Quest extends Comparable<Quest> {
  static const _AREA_MAP = {
    '修練場（月）': '修炼场（周一）',
    '修練場（火）': '修炼场（周二）',
    '修練場（水）': '修炼场（周三）',
    '修練場（木）': '修炼场（周四）',
    '修練場（金）': '修炼场（周五）',
    '修練場（土）': '修炼场（周六）',
    '修練場（日）': '修炼场（周日）',
    '冬木': '冬木',
    'オルレアン': '奥尔良',
    'セプテム': '七丘之城',
    'オケアノス': '俄刻阿诺斯',
    'ロンドン': '伦敦',
    '北米': '北美',
    'キャメロット': '卡美洛',
    'バビロニア': '巴比伦尼亚',
    '新宿': '新宿',
    'アガルタ': '雅戈泰',
    '下総国': '下总国',
    'セイレム': '塞勒姆',
    'アナスタシア': '阿纳斯塔西娅',
    'ゲッテルデメルング': '诸神黄昏',
    'シン': '秦',
    'ユガ・クシェートラ': '由伽·刹多罗',
    'アトランティス': '亚特兰蒂斯',
    'オリュンポス': '奥林波斯',
    '平安京': '平安京',
    'アヴァロン': '阿瓦隆',
    'トラオム': 'Traum',
    'ミクトラン': '米克特兰'
  };
  static const _NAMES = [
    '弓之修炼场 极级',
    '弓之修炼场 超级',
    '弓之修炼场 上级',
    '弓之修炼场 中级',
    '弓之修炼场 初级',
    '枪之修炼场 极级',
    '枪之修炼场 超级',
    '枪之修炼场 上级',
    '枪之修炼场 中级',
    '枪之修炼场 初级',
    '狂之修炼场 极级',
    '狂之修炼场 超级',
    '狂之修炼场 上级',
    '狂之修炼场 中级',
    '狂之修炼场 初级',
    '骑之修炼场 极级',
    '骑之修炼场 超级',
    '骑之修炼场 上级',
    '骑之修炼场 中级',
    '骑之修炼场 初级',
    '术之修炼场 极级',
    '术之修炼场 超级',
    '术之修炼场 上级',
    '术之修炼场 中级',
    '术之修炼场 初级',
    '杀之修炼场 极级',
    '杀之修炼场 超级',
    '杀之修炼场 上级',
    '杀之修炼场 中级',
    '杀之修炼场 初级',
    '剑之修炼场 极级',
    '剑之修炼场 超级',
    '剑之修炼场 上级',
    '剑之修炼场 中级',
    '剑之修炼场 初级',
    '未确认坐标Ｘ－Ａ',
    '未确认坐标Ｘ－Ｂ',
    '未确认坐标Ｘ－Ｃ',
    '未确认坐标Ｘ－Ｄ',
    '未确认坐标Ｘ－Ｅ',
    '未确认坐标Ｘ－Ｆ',
    '未确认坐标Ｘ－Ｇ',
    '变动坐标点０号',
    '栋雷米',
    '沃库勒尔',
    '拉沙里泰',
    '汝拉',
    '里昂',
    '马赛',
    '蒂耶尔',
    '波尔多',
    '奥尔良',
    '巴黎',
    '亚壁街道',
    '罗马',
    '埃特纳火山',
    '佛罗伦萨',
    '梅迪奥兰',
    '日耳曼尼亚',
    '马西利亚',
    '高卢',
    '不列颠尼亚',
    '有形之岛',
    '联军首都',
    '海盗船',
    '海盗岛',
    '王者的居岛',
    '地图上标记的岛',
    '暗礁海域',
    '潮眼之海',
    '翼龙之岛',
    '火山臼之岛',
    '暴风雨海域',
    '群岛（寂静的入海口）',
    '群岛（隐藏之岛）',
    '丰硕之海',
    '旧街',
    '白色教堂',
    '伦敦城',
    '苏活区',
    '威斯敏斯特',
    '摄政公园',
    '克勒肯维尔',
    '萨瑟克',
    '海德公园',
    '布拉克山',
    '里弗顿',
    '丹佛',
    '德明',
    '达拉斯',
    '阿尔卡特拉斯岛',
    '得梅因',
    '蒙哥马利',
    '拉伯克',
    '亚历山德里亚',
    '卡尼',
    '夏洛特',
    '华盛顿',
    '芝加哥',
    '沙尘暴的沙漠',
    '黎明的沙丘',
    '死之荒野',
    '东之村',
    '圆桌要塞',
    '晚钟庙',
    '西之村遗迹',
    '阿特拉斯院',
    '圣都正门',
    '圣都市街',
    '隐秘之村',
    '王城',
    '无之大地',
    '大神殿',
    '废都巴比伦',
    '北之高台',
    '黑色杉木林',
    '高原',
    '湿地',
    '乌尔',
    '埃里都',
    '观测所',
    '芦苇原',
    '库撒',
    '北壁',
    '尼普尔',
    '艾比夫山',
    '鲜血神殿',
    '代代木二丁目',
    '国道20号',
    '新宿站',
    '新宿四丁目',
    '歌舞伎町',
    '枪身塔',
    '舞会会场',
    '塔顶楼',
    '新宿御苑',
    '新宿二丁目',
    '地底平原',
    '野营地',
    '河边城市',
    '桃源乡',
    '伊苏',
    '北部断崖',
    '不夜城',
    '山脚密林',
    '龙宫城',
    '地底大河',
    '黄金国',
    '大地裂隙',
    '农田',
    '村落',
    '草庵',
    '城下町',
    '战役之地',
    '土气城',
    '后山（无名灵峰）',
    '荒川之原',
    '后山（战战兢兢）',
    '寂静之森',
    '卡特家',
    '公众集会堂',
    '码头',
    '维特利家',
    '郊外的宅邸',
    '加罗丘陵',
    '牧草地',
    '空房',
    '隐匿处',
    '拘留所',
    '锚点',
    '雅嘎·斯摩棱斯克',
    '风穴冰窟',
    '反叛军的堡垒',
    '雅嘎·瑟乔夫卡',
    '烧光的村庄',
    '雅嘎·维亚济马',
    '雅嘎·杰缅斯克',
    '雅嘎·图拉',
    '遭毁灭的村庄',
    '雅嘎·莫斯科',
    '大溪谷之堡垒',
    '大树根部',
    '雅嘎·梁赞',
    '登陆点',
    '薄冰之丘',
    '巨人的花园',
    '第23村落',
    '英雄的地窖',
    '雪与冰之城',
    '通往尽头之路',
    '炎之馆',
    '第67村落',
    '北之境界',
    '被遗忘的神殿',
    '播种地',
    '邻村',
    '冰冷窟',
    '芥之阵营',
    '景阳原',
    '山阳丘',
    '收容所',
    '石泉峡',
    '大坪峪',
    '咸阳',
    '八门洞',
    '起始点',
    '比丘',
    '隐遁窟',
    '北之灵峰',
    '西之断层',
    '迪瓦尔',
    '神之空岩遗迹',
    '南之城镇',
    '无穷之地',
    '东之花园',
    '起航点',
    '赫斯提亚岛',
    '赫卡忒岛',
    '戴摩斯岛',
    '阿斯特赖亚岛',
    '忒提斯岛',
    '厄里斯岛',
    '涅墨西斯岛',
    '塔那托斯岛',
    '滑翔点',
    '星间都市西部',
    '星间都市南部',
    '星间都市东部',
    '大工房',
    '破神同盟基地',
    '祭坛街',
    '空中庭园',
    '机神回廊',
    '大祭坛',
    '地下机构带·外围',
    '七条四坊',
    '七条二坊',
    '六条大路',
    '贵族邸',
    '朱雀门',
    '平安宫',
    '朱雀大路',
    '稻荷神社',
    '大宫大路',
    '赖光的宅邸',
    '五条桥',
    '大江山',
    '三条三坊',
    '雾之海岸',
    '康沃尔之村',
    '索尔兹伯里',
    '格洛斯特',
    '泪之河',
    '诺里奇',
    '卡美洛',
    '伦蒂尼恩',
    '曼彻斯特',
    '爱丁堡',
    '新达灵顿',
    '湖区',
    '尽头海岸',
    '奥克尼',
    '牛津',
    '多佛宅邸',
    '边界城镇',
    '破晓平原',
    '中部森林',
    '黄昏之森',
    '天崄山脉',
    '王道界域据点',
    '克桑滕之塔',
    '阿查果克堡垒',
    '湖畔平原',
    '锡尔米乌姆',
    '复权界域据点',
    '门前平原',
    '复仇界域据点',
    '莱辛巴赫',
    '止境荒野',
    '约维努斯堡垒',
    '奇科莫斯托克',
    '贤者的隐居之所',
    '玉米地',
    '特拉特拉乌基',
    '大平原',
    '奇琴伊察',
    '坠机点',
    '伊斯塔乌基',
    '墨西哥城',
    '亚亚乌基',
    '卡拉克穆尔',
    '卡恩的废墟',
    '索索亚乌基',
    '梅兹蒂特兰',
    '烤玉米地',
    '蒂卡尔遗迹'
  ];

  static final free = <Quest>[];
  static final classHalfAp = false.obs;

  final String area;
  final String name;
  final int ap;
  final int samples;
  final bronze = <int>[];
  final silver = <int>[];
  final gold = <int>[];
  final gem = <int>[];
  final int relation;
  final items = <Item>[];
  late double itemAp;

  Quest(List row, name)
      : area = _AREA_MAP[row[0]] ?? row[0],
        name = name ?? row[1],
        ap = row[2],
        samples = row[3],
        relation = row[108] {
    bronze.addAll(row.sublist(4, 17).map(_drops));
    silver.addAll(row.sublist(18, 40).map(_drops));
    gold.addAll(row.sublist(41, 60).map(_drops));
    gem.addAll(row.sublist(74, 81).map(_drops));
  }

  int _drops(rate) {
    rate = rate is num ? rate as double : 0.0;
    if (rate > 0) {
      for (int i = samples * rate ~/ 100, upper = (samples * rate / 100).ceil(); i <= upper; ++i) {
        final dropsX10 = i / samples * 1000;
        final rateX10 = (rate * 10).toInt();
        if (dropsX10.toInt() == rateX10) return i;
        // if (dropsX10.round() == rateX10) return i;
        if (dropsX10 > rateX10) {
          if (kDebugMode) debugPrint('$name $rate: drop miss');
          return i - 1;
        }
      }
    }
    return 0;
  }

  @override
  int compareTo(Quest other) => itemAp < other.itemAp ? 1 : (itemAp > other.itemAp ? -1 : 0);

  @override
  String toString() => '$area $name: AP $ap, $samples samples $bronze $silver $gold $gem';
}

class Item {
  static const _TYPES = ['bronze', 'silver', 'gold', '', '', 'gem'];
  static const _BRONZE_NAMES = [
    '英雄之证',
    '凶骨',
    '龙之牙',
    '虚影之尘',
    '愚者之锁',
    '万死的毒针',
    '魔术髓液',
    '宵泣之铁桩',
    '振荡火药',
    '赦免的小钟',
    '黄昏的仪式剑',
    '不忘之灰',
    '黑曜锐刃'
  ];
  static const _SILVER_NAMES = [
    '世界树之种',
    '鬼魂提灯',
    '八连双晶',
    '蛇之宝玉',
    '凤凰羽毛',
    '无间齿轮',
    '禁断书页',
    '人工生命体幼体',
    '陨蹄铁',
    '大骑士勋章',
    '追忆的贝壳',
    '枯淡勾玉',
    '永远结冰',
    '巨人的戒指',
    '极光之钢',
    '闲古铃',
    '祸罪之箭头',
    '光银之冠',
    '神脉灵子',
    '虹之线球',
    '梦幻的鳞粉',
    '太阳皮'
  ];
  static const _GOLD_NAMES = [
    '混沌之爪',
    '蛮神心脏',
    '龙之逆鳞',
    '精灵根',
    '战马的幼角',
    '血之泪石',
    '黑兽脂',
    '封魔之灯',
    '智慧之圣甲虫像',
    '起源的胎毛',
    '咒兽胆石',
    '奇奇神酒',
    '晓光炉心',
    '九十九镜',
    '真理之卵',
    '煌星碎片',
    '悠久果实',
    '鬼炎鬼灯'
  ];
  static const _GEM_NAMES = ['剑之秘石', '弓之秘石', '枪之秘石', '骑之秘石', '术之秘石', '杀之秘石', '狂之秘石'];

  static final bronze = <Item>[];
  static final silver = <Item>[];
  static final gold = <Item>[];
  static final gem = <Item>[];
  static final relationExclude = false.obs;

  final int type;
  final int index;
  final String name;
  final quests = <Quest>[];
  late double ap;
  final excluded = false.obs;

  Item(this.type, this.index, this.name) {
    excluded.listen((v) async => (await SharedPreferences.getInstance()).setBool(name, v));
  }

  Widget get icon => Image.asset('assets/${_TYPES[type]}_$index.png');

  List<Quest> get bestQuests {
    final fpTimes = 1;
    final apPerRelation = 0.0137182052014861;
    for (final quest in quests) {
      quest.itemAp = 0;
      quest.items.clear();
      double aps = 0;
      for (int i = 0, n = quest.bronze.length; i < n; ++i) {
        final item = Item.bronze[i];
        if ((type == 0 && index == i) || !item.excluded.value) aps += quest.bronze[i] * item.ap;
        if (quest.bronze[i] > 0) quest.items.add(item);
      }
      for (int i = 0, n = quest.silver.length; i < n; ++i) {
        final item = Item.silver[i];
        if ((type == 1 && index == i) || !item.excluded.value) aps += quest.silver[i] * item.ap;
        if (quest.silver[i] > 0) quest.items.add(item);
      }
      for (int i = 0, n = quest.gold.length; i < n; ++i) {
        final item = Item.gold[i];
        if ((type == 2 && index == i) || !item.excluded.value) aps += quest.gold[i] * item.ap;
        if (quest.gold[i] > 0) quest.items.add(item);
      }
      for (int i = 0, n = quest.gem.length; i < n; ++i) {
        final item = Item.gem[i];
        if ((type == 5 && index == i) || !item.excluded.value) aps += quest.gem[i] * item.ap;
        if (quest.gem[i] > 0) quest.items.add(item);
      }
      var ap = aps / quest.samples;
      var fp = 0;
      if (fpTimes <= 1) {
        if (quest.relation < 790) {
          if (!relationExclude.value) ap += apPerRelation * ((quest.relation * 1.30).toInt() + 50);
          fp = 175;
        } else {
          if (!relationExclude.value) ap += apPerRelation * ((quest.relation * 1.35).toInt() + 50);
          fp = 125;
        }
      } else {
        if (!relationExclude.value) ap += apPerRelation * (quest.relation * 1.325).toInt();
        fp = 200;
      }
      ap += fp * fpTimes * 0.010792291220557;
      quest.itemAp = ap / (quest.area.startsWith('修炼场') && Quest.classHalfAp.value ? quest.ap ~/ 2 : quest.ap);
    }
    List<Quest> bests = List.from(quests)..sort();
    if (bests.length > 10) bests.removeRange(10, bests.length);
    if (!bests.contains(quests[0])) {
      bests.removeLast();
      bests.add(quests[0]);
    }
    return bests;
  }

  @override
  String toString() => '$name: AP ${ap.toStringAsFixed(2)} ${quests.map((quest) => quest.name)}';
}
