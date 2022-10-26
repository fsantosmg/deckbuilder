import 'dart:io';

import 'package:deckbuilder/database/dao/mtg_card_dao.dart';
import 'package:deckbuilder/http/webclients/scryfall_api.dart';
import 'package:deckbuilder/models/mtg_card.dart';
import 'package:deckbuilder/screens/card_collection.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../http/webclients/magic_the_gathering_io.dart';

class CardReaderOcr extends StatefulWidget {
  const CardReaderOcr({Key? key}) : super(key: key);

  @override
  State<CardReaderOcr> createState() => _CardReaderOcrState();
}

class _CardReaderOcrState extends State<CardReaderOcr> {
  bool textScanning = false;

  XFile? imageFile;

  var ligaMagicUri = '';

  List<String> editions = [];
  var editionValue = ValueNotifier('');
  MtgCard scannedCard = MtgCard(
      id: 0,
      name: '',
      printedName: '',
      manaCost: '',
      cmc: 0.0,
      type: '',
      text: '');

  @override
  Widget build(BuildContext context) {
    bool isSaved = true;
    const saveOkText = 'Card salvo com sucesso!';
    const saveFailText = 'Não foi possivel salvar o card!';
    return Scaffold(
      /* appBar: AppBar(
        centerTitle: true,
        title: const Text("Adicionar Carta"),
      ), */
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Galeria",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            editionValue = ValueNotifier('');
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: scannedCard.printedName.isNotEmpty,
                  child: Column(children: [
                    ValueListenableBuilder(
                      valueListenable: editionValue,
                      builder: (BuildContext context, String value, _) {
                        return DropdownButton<String>(
                          hint: const Text("Selecionar edição"),
                          value: value.isEmpty ? null : value,
                          onChanged: (edition) =>
                              editionValue.value = edition.toString(),
                          items: editions
                              .map(
                                (op) => DropdownMenuItem(
                                  value: op,
                                  child: Text(op,
                                      style: const TextStyle(fontSize: 24)),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    Text(
                      scannedCard.printedName,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Custo: ${scannedCard.manaCost}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      scannedCard.text,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${scannedCard.power}/${scannedCard.toughness}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _launchUrl,
                      child: const Text('Ir para Liga Magic'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {
                            final snackBar = SnackBar(
                              content:
                                  Text(isSaved ? saveOkText : saveFailText),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  isSaved = createMtgCard(context);
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: const Text('Salvar'),
                          //onPressed: () => createMtgCard(context),
                          //child: const Text('Salvar'),
                        ),
                      ),
                    )
                  ]),
                )
              ],
            )),
      )),
    );
  }

  bool createMtgCard(BuildContext context) {
    final MtgCardDao _dao = MtgCardDao();
    if (scannedCard.printedName.isNotEmpty) {
      //_dao.save(scannedCard).then((id) => Navigator.pop(context));
      _dao.save(scannedCard);
      return true;
    }
    return false;
  }

  void _launchUrl() async {
    var uri = Uri.https('www.ligamagic.com.br', '/',
        {'view': 'cards/card', 'card': scannedCard.printedName, 'tipo': '1'});
    ligaMagicUri = uri.toString();
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final ScryfallApi _webClient = ScryfallApi();
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    List<String> teste = [];
    /*for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        teste.add(line.text);
      }
    }*/
    var cardName = recognisedText.blocks[0].lines[0].text;
    String regex = r'[^\p{Decimal_Number}\s]+';
    cardName = cardName.replaceAll(RegExp(r'[0-9/(/)/&]'), '').trim();

    if (double.tryParse(cardName.substring(cardName.length - 1)) != null) {
      cardName = cardName.substring(0, cardName.length - 1).trim();
    }
    if (cardName.substring(0, 1).compareTo("(") == 0) {
      cardName = cardName.substring(1, cardName.length);
    }

    /*try {
      MagicTheGatheringIo _webClient2 = MagicTheGatheringIo();
      Map<String, dynamic> cardEdit = await _webClient2.findCard(cardName);
      scannedCard = cardEdit['mtgCard'];
      editions = [];
      editions = cardEdit['editions'];
    } catch (e) {*/
      scannedCard = await _webClient.findCard(cardName);
    //}
    textScanning = false;
    await textDetector.close();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
