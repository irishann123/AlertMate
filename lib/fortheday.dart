import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ForTheDay extends StatefulWidget {
  const ForTheDay({Key? key}) : super(key: key);

  @override
  _ForTheDayState createState() => _ForTheDayState();
}

class _ForTheDayState extends State<ForTheDay> {
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

  forTheDay(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: GestureDetector(
        onLongPress: () {
          forTheDay('These are your tasks for the day');
          final snackBar = SnackBar(
            content: Text(
              'These are your tasks for the day',
              style: TextStyle(
                  color: Colors.white, fontSize: 20), // Customize text color
            ),
            backgroundColor: Color(0xff281537), // Customize background color
            duration: Duration(seconds: 5), // Optional: set the duration
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDoubleTap: () {
          forTheDay('These are your tasks for the day');
          final snackBar = SnackBar(
            content: Text(
              'These are your tasks for the day',
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
