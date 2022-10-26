import 'package:deckbuilder/screens/card_collection.dart';
import 'package:deckbuilder/screens/card_reader_ocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          CardList(),
          const CardReaderOcr(),
          Container(
            color: Colors.yellow,
          ),
          Container(
            color: Colors.yellow,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: "Cards",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web_stories),
            label: 'Decks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'perfil',
          ),
        ],
      ),
    );
  }
}
