import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';


//const _uri = 'http://192.168.1.15:8081/transactions';
const _uri = 'https://api.scryfall.com/cards/named?fuzzy=Nicol+bolas,+Drag';
Future<String> findAll() async {

  final Response response = await get(Uri.parse(_uri));
  return response.body;
}
