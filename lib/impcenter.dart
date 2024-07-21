import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImpCenter extends StatefulWidget {
  const ImpCenter({Key? key}) : super(key: key);

  @override
  _ImpCenterState createState() => _ImpCenterState();
}

class _ImpCenterState extends State<ImpCenter> {
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

  impCenter(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: GestureDetector(
        onLongPress: () {
          impCenter('Reminders you set as important');
          final snackBar = SnackBar(
            content: Text(
              'Reminders you set as important',
              style: TextStyle(
                  color: Colors.white, fontSize: 20), // Customize text color
            ),
            backgroundColor: Color(0xff281537), // Customize background color
            duration: Duration(seconds: 5), // Optional: set the duration
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDoubleTap: () {
          impCenter('Reminders you set as important');
          final snackBar = SnackBar(
            content: Text(
              'Reminders you set as important',
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
