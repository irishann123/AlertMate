import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PersonCenter extends StatefulWidget {
  const PersonCenter({Key? key}) : super(key: key);

  @override
  _PersonCenterState createState() => _PersonCenterState();
}

class _PersonCenterState extends State<PersonCenter> {
  late final FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    initializeTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
  }

  speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: GestureDetector(
        onLongPress: () {
          speak('Click on edit to modify your emergency contact!!');
          final snackBar = SnackBar(
            content: Text(
              'Click on edit to modify your emergency contact!!',
              style: TextStyle(
                  color: Colors.white, fontSize: 20), // Customize text color
            ),
            backgroundColor: Color(0xff281537), // Customize background color
            duration: Duration(seconds: 5), // Optional: set the duration
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDoubleTap: () {
          speak('Click on edit to modify your emergency contact!!');
          final snackBar = SnackBar(
            content: Text(
              'Click on edit to modify your emergency contact!!',
              style: TextStyle(
                  color: Colors.white, fontSize: 20), // Customize text color
            ),
            backgroundColor: Color(0xff281537), // Customize background color
            duration: Duration(seconds: 5), // Optional: set the duration
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xff281537),
          shape: CircleBorder(),
          child: Icon(Icons.favorite, color: Colors.white, size: 30.0),
          elevation: 0.1,
        ),
      ),
    );
  }
}
