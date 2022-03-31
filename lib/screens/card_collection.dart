import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OCRPage extends StatefulWidget{
  const OCRPage({Key? key}) : super(key: key);

  @override
  _OCRPageState createState() => _OCRPageState();

}

class _OCRPageState extends State<OCRPage> {
  final int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('OCR In Flutter'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_text,style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _read,
                child: const Text('Scanning',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(

        camera: _ocrCamera,
        fps: 2.0,
        waitTap: true,
      );
      setState(() {
        _text = texts[0].value;
      });
    } on Exception {
      texts.add( OcrText('Failed to recognize text'));
    }
  }
}
