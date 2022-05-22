import 'package:deckbuilder/database/dao/mtg_card_dao.dart';
import 'package:deckbuilder/models/mtg_card.dart';
import 'package:deckbuilder/screens/card_reader_ocr.dart';
import 'package:flutter/material.dart';

import '../widgets/progress.dart';

class CardList extends StatefulWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();

}

class _CardListState extends State<CardList>{
  final MtgCardDao _dao = MtgCardDao();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck name'),
      ),
      body: FutureBuilder<List<MtgCard>>(
        initialData: const [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List mtgCards = snapshot.data as List<MtgCard>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final contact = mtgCards[index];
                  return _MtgCardItem(contact, onClick: () {},);
                },
                itemCount: mtgCards.length,
              );
          }
          return const Text('Erro desconhecido');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const CardReaderOcr(),
            ),
          )
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MtgCardItem extends StatelessWidget {
  final MtgCard mtgCard;
  final Function onClick;

  const _MtgCardItem(this.mtgCard, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          mtgCard.name,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          mtgCard.manaCost,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}