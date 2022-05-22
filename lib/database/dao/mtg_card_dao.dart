import 'package:sqflite/sqflite.dart';

import '../../models/mtg_card.dart';
import '../app_database.dart';

class MtgCardDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'printed_name TEXT, '
      'mana_cost TEXT, '
      'cmc REAL, '
      'type TEXT, '
      'text TEXT, '
      'power TEXT, '
      'toughness TEXT, '
      'link_liga_magic TEXT)';


  static const String _tableName = 'mtgcard';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _printedName = 'printed_name';
  static const String _manaCost = 'mana_cost';
  static const String _cmc = 'cmc';
  static const String _type = 'type';
  static const String _text = 'text';
  static const String _power = 'power';
  static const String _toughness = 'toughness';
  static const String _linkLigaMagic = 'link_liga_magic';

  Future<int> save(MtgCard mtgCard) async {
    final Database db = await getDatabase();
    Map<String, dynamic> mtgCardMap = _toMap(mtgCard);
    return db.insert(_tableName, mtgCardMap);
  }

  Map<String, dynamic> _toMap(MtgCard mtgCard) {
    final Map<String, dynamic> mtgCardMap = {};
    mtgCardMap[_name] = mtgCard.name;
    mtgCardMap[_printedName] = mtgCard.printedName;
    mtgCardMap[_manaCost] = mtgCard.manaCost;
    mtgCardMap[_cmc] = mtgCard.cmc;
    mtgCardMap[_type] = mtgCard.type;
    mtgCardMap[_text] = mtgCard.text;
    mtgCardMap[_power] = mtgCard.power;
    mtgCardMap[_toughness] = mtgCard.toughness;
    mtgCardMap[_linkLigaMagic] = mtgCard.toughness;


    return mtgCardMap;
  }

  Future<List<MtgCard>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<MtgCard> mtgCards = _toList(result);
    return mtgCards;
  }

  List<MtgCard> _toList(List<Map<String, dynamic>> result) {
    final List<MtgCard> mtgCards = [];
    for (Map<String, dynamic> row in result) {
      final MtgCard mtgCard = MtgCard(
        id: row[_id],
        name: row[_name],
        printedName: row[_printedName],
        manaCost: row[_manaCost],
        cmc: row[_cmc],
        type: row[_type],
        text: row[_text],
        power: row[_power],
        toughness: row[_toughness],
        linkLigaMagic: row[_linkLigaMagic]
      );
      mtgCards.add(mtgCard);
    }
    return mtgCards;
  }
}
