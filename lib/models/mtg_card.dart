import 'dart:convert';

class MtgCard {
  final int id;
  final String name;
  final String printedName;
  final String manaCost;
  final double cmc;
  final String type;
  final String text;
  final String? power;
  final String? toughness;
  final String? setEdition;
  final String? linkLigaMagic;

  MtgCard(
      {required this.id,
      required this.name,
      required this.printedName,
      required this.manaCost,
      required this.cmc,
      required this.type,
      required this.text,
      this.power,
      this.toughness,
      this.setEdition,
      this.linkLigaMagic});

  MtgCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        printedName = json['printedName'],
        manaCost = json['manaCost'],
        cmc = json['cmc'],
        type = json['type'],
        text = json['text'],
        power = json['power'],
        toughness = json['toughness'],
        setEdition = json['setEdition'],
        linkLigaMagic = json['linkLigaMagic'];

  @override
  String toString() {
    return 'MtgCard{\nid: $id \n, name: $name \n, manaCost: $manaCost\n, cmc: $cmc\n, type: $type\n, text: $text\n, power: $power\n, toughness: $toughness\n}';
  }
}
