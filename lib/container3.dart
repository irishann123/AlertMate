import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'comp2_cpy.dart';
import 'check_new1.dart';
import 'check_2.dart';
import 'background_scaffold.dart';
import 'bottom_bar.dart';
import 'Addlist.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class GradientContainer extends StatefulWidget {
  const GradientContainer({Key? key}) : super(key: key);

  @override
  State<GradientContainer> createState() {
    return _GradientContainerState();
  }
}

class _GradientContainerState extends State<GradientContainer> {
  late Widget activeScreen;

  @override
  void initState() {
    super.initState();
    activeScreen = Comp(switchScreen);
  }

  void switchScreen() {
    setState(() {
      activeScreen = CheckList1();
    });
  }

  void switchScreen2() {
    setState(() {
      activeScreen = const Check2();
    });
  }

  final List<String> buttonTitles = ['Custom Button', 'Button 1'];
  @override
  Widget build(context) {
    return MaterialApp(
      home: BackgroundScaffold(
        title: 'To Do List ',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: activeScreen,
            ),
            // Use Spacer to push BottomBar to the bottom
            //Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80, // Adjust the height as needed
                child: BottomBar(
                  centerWidget: AddList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
