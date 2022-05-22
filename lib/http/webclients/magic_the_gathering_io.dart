import 'dart:convert';

import 'package:deckbuilder/http/webclient.dart';
import 'package:http/http.dart';

import '../../models/mtg_card.dart';

const _uri = 'api.magicthegathering.io';
const _findCard = 'v1/cards/';

class MagicTheGatheringIo {
  static const String ptBr = 'Portuguese (Brazil)';
  static const String language = 'language';
  static const String foreignNames = 'foreignNames';

  Future<Map<String, dynamic>> findCard(String cardName) async {
    Map<String, dynamic> parameter = {'name': cardName};
    Map<String, dynamic> cardMap = {};

    parameter[language] = ptBr;
    List cards = await _getCard(parameter);

    if (cards.isEmpty) {
      parameter.remove(language);
      cards = await _getCard(parameter);
    }

    if (cards.isNotEmpty) {
      cardMap = Map<String, dynamic>.from(cards.last);
    }

    return _createCard(cardMap);
  }

  Future<List> _getCard(Map<String, dynamic> parameter) async {
    final Response response = await client
        .get(Uri.http(_uri, _findCard, parameter))
        .timeout(const Duration(seconds: 10));

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    List<dynamic> cards = decodedJson['cards'];
    return cards;
  }

  Map<String, dynamic> _createCard(Map<String, dynamic> cardMap) {
    MtgCard mtgCard = MtgCard(
        id: 0,
        name: cardMap['name'],
        printedName: cardMap.containsKey('printed_name')
            ? cardMap['printed_name']
            : cardMap['name'],
        manaCost: cardMap['manaCost'],
        cmc: cardMap['cmc'],
        type: cardMap['type'],
        text: getText(cardMap),
        power: cardMap.containsKey('power') ? cardMap['power'] : '',
        toughness:
            cardMap.containsKey('toughness') ? cardMap['toughness'] : '',
       linkLigaMagic: 'https://www.ligamagic.com.br/?view=cards%2Fcard&card=${cardMap['name']}&tipo=1'

    );

    // printings:

    Map<String, dynamic> cardEdit = {'mtgCard': mtgCard};
    List<String> editions = [];
    cardMap['printings'].forEach((e) => {editions.add(e.toString())});

    cardEdit['editions'] = editions;

    return cardEdit;
  }

  String getText(Map<String, dynamic> cardMap) {
    var text = '';
    if (cardMap.containsKey(foreignNames)) {
      for (Map e in cardMap[foreignNames]) {
        if (e[language] == ptBr) {
          return e['text'];
        }
      }
    }
    return cardMap['text'];
  }
}
