import 'package:flutter/material.dart';
import 'background_scaffold.dart'; 
import 'bottom_bar.dart';
import 'calendar_widget.dart';
import 'heartcenter.dart';
import 'alert.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userEmail = getCurrentUserEmail(); // Retrieve current user's email
    startAlertChecks(context, userEmail); // Call the function here to start periodic checks

    return BackgroundScaffold(
      title: 'Calendar',
      body: Stack(
        children: [
          CalendarWidget(),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              // ignore: prefer_const_constructors
              child: BottomBar(
                // ignore: prefer_const_constructors
                centerWidget: CenterHeart(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
