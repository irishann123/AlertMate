import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CenterHeart extends StatefulWidget {
  const CenterHeart({Key? key}) : super(key: key);

  @override
  _CenterHeartState createState() => _CenterHeartState();
}

class _CenterHeartState extends State<CenterHeart> {
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
          speak('Click on any date on the calendar to view events for the day or to add more!!');
          final snackBar = SnackBar(
            content: Text(
              'Click on any date on the calendar to view events for the day or to add more!!',
              style: TextStyle(
                  color: Colors.white, fontSize: 20), // Customize text color
            ),
            backgroundColor: Color(0xff281537), // Customize background color
            duration: Duration(seconds: 5), // Optional: set the duration
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDoubleTap: () {
          speak('Click on any date on the calendar to view events for the day or to add more!!');
          final snackBar = SnackBar(
            content: Text(
              'Click on any date on the calendar to view events for the day or to add more!!',
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
