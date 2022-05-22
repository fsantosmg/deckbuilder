import 'dart:convert';

import 'package:deckbuilder/http/webclient.dart';
import 'package:deckbuilder/http/webclients/magic_the_gathering_io.dart';
import 'package:http/http.dart';

import '../../models/mtg_card.dart';

const _uri = 'api.scryfall.com';
const _findCard = 'cards/named';

class ScryfallApi {
  Future<MtgCard> findCard(String cardName) async {
    Map<String, dynamic> parameter = {'fuzzy': cardName};

    Response response = await client
        .get(Uri.https(_uri, _findCard, parameter))
        .timeout(const Duration(seconds: 10));

    final Map<String, dynamic> cardMap = jsonDecode(response.body);

    MtgCard mtgCard;

    mtgCard = _createCard(cardMap, cardName);

    return mtgCard;
  }

  MtgCard _createCard(Map<String, dynamic> cardMap, String cardName) {
    MtgCard mtgCard;

    mtgCard = MtgCard(
        id: 0,
        name: cardMap['name'],
        printedName: cardMap.containsKey('printed_name')
            ? cardMap['printed_name']
            : cardMap['name'],
        manaCost: cardMap['mana_cost'],
        cmc: cardMap['cmc'],
        type: cardMap['type_line'],
        text: cardMap.containsKey('printed_text') ? cardMap['printed_text'] : cardMap['oracle_text'],
        power: cardMap.containsKey('power') ? cardMap['power'] : '',
        toughness:
            cardMap.containsKey('toughness') ? cardMap['toughness'] : '');

    return mtgCard;
  }
}
